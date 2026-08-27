#include <array>
#include <chrono>
#include <cstdlib>
#include <cstring>
#include <filesystem>
#include <format>
#include <iostream>
#include <optional>
#include <sstream>
#include <stdexcept>
#include <string>
#include <string_view>
#include <sys/types.h>
#include <sys/wait.h>
#include <unistd.h>
#include <vector>

namespace fs = std::filesystem;

enum class Mode { Full, Area };

struct Options {
    Mode mode = Mode::Area;
    fs::path output;
    bool save_file = false;
    bool output_given = false;
};

static std::string now_timestamp() {
    using namespace std::chrono;
    auto now = system_clock::now();
    auto t = system_clock::to_time_t(now);

    std::tm tm{};
    localtime_r(&t, &tm);

    char buf[64];
    std::strftime(buf, sizeof(buf), "%Y-%m-%d_%H-%M-%S", &tm);
    return std::string(buf);
}

static fs::path default_output_path() {
    const char* home = std::getenv("HOME");
    fs::path base = (home && *home)
        ? fs::path(home) / "Pictures" / "Screenshots"
        : fs::current_path();
    fs::create_directories(base);
    return base / ("Screenshot_" + now_timestamp() + ".png");
}

static bool executable_in_path(std::string_view name) {
    const char* path_env = std::getenv("PATH");
    if (!path_env) return false;
    std::string path_str(path_env);
    std::stringstream ss(path_str);
    std::string dir;
    while (std::getline(ss, dir, ':')) {
        if (dir.empty()) continue;
        fs::path p = fs::path(dir) / name;
        if (fs::exists(p) && access(p.c_str(), X_OK) == 0)
            return true;
    }
    return false;
}

struct ProcessResult {
    int exit_code = -1;
    std::string stdout_text;
    std::string stderr_text;
};

// Runs argv, capturing stdout and stderr separately.
// If stdin_fd != -1, it is dup2'd onto STDIN_FILENO in the child.
static ProcessResult run_capture(
    const std::vector<std::string>& argv,
    int stdin_fd = -1
) {
    int out_pipe[2], err_pipe[2];
    if (pipe(out_pipe) == -1 || pipe(err_pipe) == -1)
        throw std::runtime_error("pipe() failed");

    pid_t pid = fork();
    if (pid < 0) {
        close(out_pipe[0]); close(out_pipe[1]);
        close(err_pipe[0]); close(err_pipe[1]);
        throw std::runtime_error("fork() failed");
    }

    if (pid == 0) {
        if (stdin_fd != -1) dup2(stdin_fd, STDIN_FILENO);
        dup2(out_pipe[1], STDOUT_FILENO);
        dup2(err_pipe[1], STDERR_FILENO);
        close(out_pipe[0]); close(out_pipe[1]);
        close(err_pipe[0]); close(err_pipe[1]);
        if (stdin_fd != -1) close(stdin_fd);

        std::vector<char*> args;
        args.reserve(argv.size() + 1);
        for (const auto& s : argv)
            args.push_back(const_cast<char*>(s.c_str()));
        args.push_back(nullptr);
        execvp(args[0], args.data());
        _exit(127);
    }

    // Parent: close write ends.
    close(out_pipe[1]);
    close(err_pipe[1]);
    if (stdin_fd != -1) close(stdin_fd);

    auto read_all = [](int fd) -> std::string {
        std::string out;
        std::array<char, 4096> buf{};
        ssize_t n;
        while ((n = read(fd, buf.data(), buf.size())) > 0)
            out.append(buf.data(), static_cast<std::size_t>(n));
        return out;
    };

    // Read stdout first, then stderr.
    // Safe here because the programs we capture (grim, slurp, wl-copy) do not
    // produce large stdout AND large stderr simultaneously, so no pipe deadlock.
    ProcessResult result;
    result.stdout_text = read_all(out_pipe[0]);
    result.stderr_text = read_all(err_pipe[0]);
    close(out_pipe[0]);
    close(err_pipe[0]);

    int status = 0;
    waitpid(pid, &status, 0);
    result.exit_code = WIFEXITED(status) ? WEXITSTATUS(status) : -1;
    return result;
}

static std::string run_slurp() {
    auto res = run_capture({"slurp"});
    if (res.exit_code != 0)
        throw std::runtime_error(
            "slurp failed with exit code " + std::to_string(res.exit_code) +
            (res.stderr_text.empty() ? "" : (": " + res.stderr_text)));
    while (!res.stdout_text.empty() &&
           (res.stdout_text.back() == '\n' || res.stdout_text.back() == '\r'))
        res.stdout_text.pop_back();
    if (res.stdout_text.empty())
        throw std::runtime_error("slurp returned empty selection");
    return res.stdout_text;
}

static void run_grim_full_to_file(const fs::path& output) {
    auto res = run_capture({"grim", output.string()});
    if (res.exit_code != 0)
        throw std::runtime_error(
            "grim failed with exit code " + std::to_string(res.exit_code) +
            (res.stderr_text.empty() ? "" : (": " + res.stderr_text)));
}

static void run_grim_area_to_file(const std::string& geometry, const fs::path& output) {
    auto res = run_capture({"grim", "-g", geometry, output.string()});
    if (res.exit_code != 0)
        throw std::runtime_error(
            "grim failed with exit code " + std::to_string(res.exit_code) +
            (res.stderr_text.empty() ? "" : (": " + res.stderr_text)));
}

// Pipes grim's stdout directly into wl-copy's stdin.
// Both are forked; we collect exit codes after both finish.
// We do NOT capture wl-copy's stdout/stderr with additional pipes because that
// would require concurrent reads to avoid deadlock when pipe buffers fill.
// Instead we let wl-copy inherit the terminal's stderr so errors still appear.
static void run_pipeline_to_clipboard(const std::vector<std::string>& grim_argv) {
    int pipefd[2];
    if (pipe(pipefd) == -1)
        throw std::runtime_error("pipe() failed");

    // Fork grim — writes PNG to pipefd[1].
    pid_t grim_pid = fork();
    if (grim_pid < 0) {
        close(pipefd[0]); close(pipefd[1]);
        throw std::runtime_error("fork() failed for grim");
    }
    if (grim_pid == 0) {
        dup2(pipefd[1], STDOUT_FILENO);
        close(pipefd[0]);
        close(pipefd[1]);
        std::vector<char*> args;
        args.reserve(grim_argv.size() + 1);
        for (const auto& s : grim_argv)
            args.push_back(const_cast<char*>(s.c_str()));
        args.push_back(nullptr);
        execvp(args[0], args.data());
        _exit(127);
    }

    // Fork wl-copy — reads PNG from pipefd[0].
    // Inherits stderr from the parent (terminal), so errors are visible.
    pid_t wlcopy_pid = fork();
    if (wlcopy_pid < 0) {
        close(pipefd[0]); close(pipefd[1]);
        // Reap grim before throwing.
        waitpid(grim_pid, nullptr, 0);
        throw std::runtime_error("fork() failed for wl-copy");
    }
    if (wlcopy_pid == 0) {
        dup2(pipefd[0], STDIN_FILENO);
        close(pipefd[0]);
        close(pipefd[1]);
        execlp("wl-copy", "wl-copy", "--type", "image/png", nullptr);
        _exit(127);
    }

    // Parent closes both ends — children own them now.
    close(pipefd[0]);
    close(pipefd[1]);

    // Reap both children.
    int grim_status = 0, wlcopy_status = 0;
    waitpid(grim_pid, &grim_status, 0);
    waitpid(wlcopy_pid, &wlcopy_status, 0);

    int grim_exit    = WIFEXITED(grim_status)   ? WEXITSTATUS(grim_status)   : -1;
    int wlcopy_exit  = WIFEXITED(wlcopy_status) ? WEXITSTATUS(wlcopy_status) : -1;

    if (grim_exit != 0)
        throw std::runtime_error("grim failed with exit code " + std::to_string(grim_exit));
    if (wlcopy_exit != 0)
        throw std::runtime_error("wl-copy failed with exit code " + std::to_string(wlcopy_exit));
}

static void run_grim_full_to_clipboard() {
    run_pipeline_to_clipboard({"grim", "-"});
}

static void run_grim_area_to_clipboard(const std::string& geometry) {
    run_pipeline_to_clipboard({"grim", "-g", geometry, "-"});
}

static void print_usage(const char* argv0) {
    std::cerr
        << "Usage:\n"
        << "  " << argv0 << " full [--save] [-o OUTPUT]\n"
        << "  " << argv0 << " area [--save] [-o OUTPUT]\n";
}

static std::optional<Options> parse_args(int argc, char** argv) {
    if (argc < 2) return std::nullopt;

    Options opt;
    std::string mode = argv[1];
    if (mode == "full")       opt.mode = Mode::Full;
    else if (mode == "area")  opt.mode = Mode::Area;
    else                      return std::nullopt;

    for (int i = 2; i < argc; ++i) {
        std::string_view arg = argv[i];
        if (arg == "-o" || arg == "--output") {
            if (i + 1 >= argc)
                throw std::runtime_error("missing value for --output");
            opt.output = argv[++i];
            opt.output_given = true;
            opt.save_file = true;
        } else if (arg == "--save") {
            opt.save_file = true;
        } else {
            throw std::runtime_error(std::format("unknown argument: {}", std::string(arg)));
        }
    }

    if (opt.save_file && !opt.output_given)
        opt.output = default_output_path();

    return opt;
}

static void ensure_wayland() {
    const char* wayland = std::getenv("WAYLAND_DISPLAY");
    if (!wayland || !*wayland)
        throw std::runtime_error(
            "WAYLAND_DISPLAY is not set; this program must run under Wayland");
}

int main(int argc, char** argv) {
    try {
        auto opt = parse_args(argc, argv);
        if (!opt) {
            print_usage(argv[0]);
            return 2;
        }

        ensure_wayland();

        if (!executable_in_path("grim"))
            throw std::runtime_error("grim is not installed or not in PATH");
        if (!executable_in_path("wl-copy"))
            throw std::runtime_error("wl-copy is not installed or not in PATH");
        if (opt->mode == Mode::Area && !executable_in_path("slurp"))
            throw std::runtime_error("slurp is not installed or not in PATH");

        std::optional<std::string> geometry;
        if (opt->mode == Mode::Area)
            geometry = run_slurp();

        if (opt->save_file) {
            fs::create_directories(opt->output.parent_path());
            switch (opt->mode) {
                case Mode::Full: run_grim_full_to_file(opt->output);             break;
                case Mode::Area: run_grim_area_to_file(*geometry, opt->output);  break;
            }
        }

        switch (opt->mode) {
            case Mode::Full: run_grim_full_to_clipboard();             break;
            case Mode::Area: run_grim_area_to_clipboard(*geometry);    break;
        }

        if (opt->save_file)
            std::cout << opt->output << '\n';

        return 0;
    } catch (const std::exception& e) {
        std::cerr << "error: " << e.what() << '\n';
        return 1;
    }
}
