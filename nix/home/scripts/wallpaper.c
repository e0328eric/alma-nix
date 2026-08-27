#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <strings.h> // not c standard (strcasecmp)
#include <stdint.h>
#include <dirent.h>
#include <time.h>
#include <unistd.h>
#include <sys/stat.h>
#include <sys/types.h>

#define MAX_PATH 1024
#define CMD_BUF_SIZE 256
#define LAPTOP_WALLPAPER "columbina-moonlit-requiem.png"

typedef struct {
    uint32_t state;
} Rng;

static Rng rng_init(void) {
    Rng rng;
    struct timespec ts;
    clock_gettime(CLOCK_MONOTONIC, &ts);
    rng.state = (uint32_t)((ts.tv_sec ^ ts.tv_nsec) | 1);
    return rng;
}

// Xorshift32 Algorithm
static uint32_t rng_next(Rng* rng) {
    uint32_t x = rng->state;
    x ^= x << 13;
    x ^= x >> 17;
    x ^= x << 5;
    return rng->state = x;
}

// eliminates modulo bias
// This uses a simple rejection sampling method
static uint32_t rng_bound(Rng* rng, uint32_t bound) {
    uint32_t threshold = -bound % bound; // 2**32 (mod bound) without making
                                         // any overflow
    while (1) {
        uint32_t r = rng_next(rng);
        if (r >= threshold) return r % bound;
    }
}

typedef struct {
    char** paths;
    size_t count;
    size_t capacity;
} ImageList;

static int is_image(const char* filename) {
    const char* dot = strrchr(filename, '.');
    if (!dot) return 0;
    
    // strcasecmp is a POSIX function (standard on Linux)
    return (strcasecmp(dot, ".png") == 0 || 
            strcasecmp(dot, ".jpg") == 0 || 
            strcasecmp(dot, ".jpeg") == 0 || 
            strcasecmp(dot, ".gif") == 0);
}

static void add_image(ImageList* list, const char* full_path) {
    if (list->count >= list->capacity) {
        list->capacity = (list->capacity == 0) ? 16 : list->capacity * 2;
        list->paths = realloc(list->paths, list->capacity * sizeof(char *));
        if (!list->paths) { perror("realloc"); exit(1); }
    }
    list->paths[list->count] = strdup(full_path);
    list->count++;
}

static void shuffle_images(ImageList *list) {
    if (list->count <= 1) return;

    Rng rng = rng_init();

    for (size_t i = list->count - 1; i > 0; i--) {
        size_t j = rng_bound(&rng, i + 1);
        char *temp = list->paths[i];
        list->paths[i] = list->paths[j];
        list->paths[j] = temp;
    }
}

static void free_images(ImageList* list) {
    for (size_t i = 0; i < list->count; i++) {
        free(list->paths[i]);
    }
    free(list->paths);
}

int main(void) {
    char wallpaper_dir[MAX_PATH];
    const char *home = getenv("HOME");
    
    if (!home) {
        fprintf(stderr, "Error: HOME environment variable not set.\n");
        return 1;
    }

    snprintf(wallpaper_dir, sizeof(wallpaper_dir), "%s/.config/alma-wallpapers", home);

    if (system("pidof awww-daemon > /dev/null 2>&1") != 0) {
        printf("[C] Starting awww-daemon...\n");
        system("awww-daemon --format xrgb &");
        usleep(500000); // 0.5 seconds
    }

    DIR* d;
    struct dirent* dir;
    ImageList images = {0};

    d = opendir(wallpaper_dir);
    if (!d) {
        fprintf(stderr, "Error: Directory not found: %s\n", wallpaper_dir);
        return 1;
    }

    char full_path[MAX_PATH];
    struct stat img_stat;
    while ((dir = readdir(d)) != NULL) {
        switch (dir->d_type) {
            case DT_REG:
            case DT_LNK:
                snprintf(full_path, sizeof(full_path), "%s/%s", wallpaper_dir, dir->d_name);
                if (dir->d_type == DT_REG) break;
                if (stat(full_path, &img_stat) != 0) continue;
                if (!S_ISREG(img_stat.st_mode)) continue;
                break;
            default: continue;
        }
        if (is_image(dir->d_name) && strcmp(dir->d_name, LAPTOP_WALLPAPER) != 0) {
            add_image(&images, full_path);
        }
    }
    closedir(d);

    if (images.count == 0) {
        fprintf(stderr, "No images found in %s\n", wallpaper_dir);
        return 1;
    }

    shuffle_images(&images);

#if defined(HYPRLAND)
    FILE *fp = popen("hyprctl monitors", "r");
#elif defined(NIRI)
    FILE *fp = popen("niri msg outputs", "r");
#else
#error "Only Hyprland or Niri are available"
#endif
    if (!fp) {
        perror("popen failed");
        free_images(&images);
        return 1;
    }

    char line[512];
    size_t img_idx = 0;
    char cmd[MAX_PATH * 2]; // Buffer for the resulting shell command

    while (fgets(line, sizeof(line), fp) != NULL) {
#if defined(HYPRLAND)
        char* mon_start = strstr(line, "Monitor ");
#elif defined(NIRI)
        char* mon_start = strstr(line, "Output ");
#else
#error "Only Hyprland or Niri are available"
#endif
        if (!mon_start) continue;

        char mon_name[64] = {0};
#if defined(HYPRLAND)
        char* name_start = mon_start + 8; // skip "Monitor "
        char* name_end = strstr(name_start, " (");
#elif defined(NIRI)
        char* name_start = strstr(mon_start, " (") + 2; // skip " ("
        char* name_end = strstr(name_start, ")");
#else
#error "Only Hyprland or Niri are available"
#endif
        if (!name_end) continue;

        size_t len = name_end - name_start;
        if (len < sizeof(mon_name)) {
            strncpy(mon_name, name_start, len);
            mon_name[len] = '\0';
        }

        printf("Detected Monitor: %s\n", mon_name);
        cmd[0] = '\0';

#ifdef USE_DEFAULT_WALLPAPER
        if (strstr(mon_name, "eDP")) {
            snprintf(cmd, sizeof(cmd), 
                "awww img -o %s \"%s/%s\" --transition-type grow",
                mon_name, wallpaper_dir, LAPTOP_WALLPAPER);
        } 
        else if (strstr(mon_name, "HDMI") || strstr(mon_name, "DP")) {
#else
        if (strstr(mon_name, "eDP") || strstr(mon_name, "HDMI") || strstr(mon_name, "DP")) {
#endif
            if (img_idx >= images.count) img_idx = 0;
            
            snprintf(cmd, sizeof(cmd), 
                "awww img -o %s \"%s\" --transition-type random --transition-step 90 --transition-fps 60",
                mon_name, images.paths[img_idx]);
            
            img_idx++;
        }

        if (cmd[0] != '\0') system(cmd);
    }

    pclose(fp);
    free_images(&images);

    return 0;
}