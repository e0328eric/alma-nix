#include <stdio.h>
#include <stdlib.h>
#include <string.h>

#define CMD_CAPACITY 1024

typedef enum {
    EXT_INVALID = -1,
    EXT_ASS,
    EXT_SMI,
    EXT_SRT,
} Extension;

static Extension getExtension(const char* subtitle_name) {
    const char* dot = strrchr(subtitle_name, '.');
    if (!dot) return EXT_INVALID;
    if (strcmp(dot, ".ass") == 0) return EXT_ASS;
    if (strcmp(dot, ".smi") == 0) return EXT_SMI;
    if (strcmp(dot, ".srt") == 0) return EXT_SRT;
    return EXT_INVALID;
}

static const char* getOutputName(const char* title) {
    size_t len = strlen(title);
    const char* dot = strrchr(title, '.');
    char* output = malloc(len + 20);

    snprintf(output, len + 20, "%.*s_subtitled%s", dot - title, title, dot);

    return output;
}

int main(int argc, char** argv) {
    if (argc != 3) {
        fprintf(stderr, "ERROR: invalid argument\n");
        fprintf(stderr, "USAGE: %s <mp4> <subtitle>\n", argv[0]);
        return 1;
    }

    const char* video_name = argv[1];
    const char* subtitle_name = argv[2];
    Extension ext = getExtension(subtitle_name);

    const char* output_name = getOutputName(video_name);
    char cmd[CMD_CAPACITY];

    switch (ext) {
    case EXT_ASS:
        snprintf(cmd, CMD_CAPACITY,
            "ffmpeg -hwaccel auto -i \"%s\" -vf \"ass='%s'\" -c:v h264_nvenc -cq 20 -c:a copy \"%s\"",
                video_name, subtitle_name, output_name);
        break;
    case EXT_SRT:
        snprintf(cmd, CMD_CAPACITY,
                "ffmpeg -hwaccel auto -i \"%s\" -vf \"subtitles='%s'\" -c:v h264_nvenc -cq 20 -c:a copy \"%s\"",
                video_name, subtitle_name, output_name);
        break;
    default:
        fprintf(stderr, "ERROR: invalid extension\n");
        free(output_name);
        return 1;
    }
    system(cmd);

    free(output_name);

    return 0;
}
