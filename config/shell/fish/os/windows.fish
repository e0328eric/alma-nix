set PATH $PATH ~/.local/bin
set PATH $PATH ~/.local/gcc/bin
set PATH $PATH ~/.local/farbfeld
set PATH $PATH /c/ghcup/bin
set PATH $PATH /c/Users/almag/AppData/Roaming/local/bin
set PATH $PATH /c/texlive/2024/bin/windows
set PATH $PATH /c/Users/almag/.rustup/toolchains/stable-x86_64-unknown-linux-gnu/bin
set PATH $PATH /c/Users/almag/.rustup/toolchains/stable-x86_64-unknown-linux-gnu/lib
set PATH $PATH /c/Users/almag/.cargo/bin
set PATH $PATH /c/Users/almag/.julia/juliaup/julia-1.11.3+0.x64.w64.mingw32/bin/
set PATH $PATH /c/Users/almag/.local/zig
set PATH $PATH ~/.nimble/bin
set PATH $PATH ~/.stack/bin
set PATH $PATH ~/.local/share/nvim/mason/bin
set PATH $PATH /c/Program\ Files/Neovim/bin
set VCPKG_ROOT ~/.local/vcpkg
set -gx INCLUDE '/home/almag/.local/fasm/INCLUDE'

function winhome
    cd /c/Users/almag/
end

function v
    nvim $argv
end

function oldrm
    /usr/bin/rm $argv
end

function rm
    xilo $argv
end

function c
    clear
end

function pbcopy
    win32yank.exe -i $argv
end

function lg
    lazygit $argv
end

function fishcfg
    v ~/.config/fish/os/windows.fish
end

function reloadfish
    source ~/.config/fish/config.fish
end

function s
    ls $argv
end

function hakwon
    cd /c/Users/almag/IceDrive/TeX_Documents/Hakwon
end

function minireport
    cd /c/Users/almag/IceDrive/TeX_Documents/Mini_Report
end

function notetaking
    cd /c/Users/almag/IceDrive/TeX_Documents/NoteTaking
end

function homework
    cd /c/Users/almag/IceDrive/TeX_Documents/Homework
end

function lecturenote
    cd /c/Users/almag/IceDrive/TeX_Documents/Lecture_Note
end

function mathbook
    cd /c/Users/almag/IceDrive/Math
end

function teachingf
    cd /c/Users/almag/IceDrive/TeX_Documents/TF
end

function seminar
    cd /c/Users/almag/IceDrive/TeX_Documents/Seminar
end

function kindergarten
    cd /c/Users/almag/IceDrive/TeX_Documents/Kindergarten
end

#          ╭──────────────────────────────────────────────────────────╮
#          │                  Initialize oh-my-posh                   │
#          ╰──────────────────────────────────────────────────────────╯

oh-my-posh init fish --config "https://raw.githubusercontent.com/JanDeDobbeleer/oh-my-posh/refs/heads/main/themes/stelbent.minimal.omp.json" | source
