# Define a default editor
set -gx EDITOR nvim

set DENO_INSTALL "/Users/almagest/.deno"

set PATH $PATH /usr/local/texlive/2021/bin/universal-darwin
set PATH "$DENO_INSTALL/bin:$PATH"
set PATH $PATH /Users/almagest/.local/bin
set PATH $PATH /Users/almagest/.local/x86_64-elf/bin
set PATH $PATH /Users/almagest/.local/i386-elf/bin
set PATH $PATH /Users/almagest/.local/gnu/bin
set PATH $PATH /Users/almagest/.local/grub-2.06/build
set PATH $PATH /Users/almagest/.cargo/bin
set PATH $PATH /Users/almagest/.go/bin
set PATH $PATH /Users/almagest/.ghcup/bin
set PATH $PATH /Users/almagest/.cabal/bin
set PATH $PATH /Users/almagest/.nimble/bin
set PATH $PATH /Users/almagest/.flutter/bin
set PATH $PATH /Users/almagest/.npm-global/bin
set PATH $PATH /Users/almagest/.opam/default/bin
set PATH $PATH /usr/local/bin
set PATH $PATH /usr/local/opt/qt/bin
set PATH $PATH /usr/local/opt/llvm/bin
set PATH $PATH /usr/local/go/bin
set PATH $PATH /usr/local/opt/python@3.10/Frameworks/Python.framework/Versions/3.10/bin
set PATH $PATH /Users/almagest/Library/Application\ Support/Coursier/bin
set PATH $PATH /opt/local/bin
set PATH $PATH /opt/local/sbin
set PATH $PATH /Users/almagest/.local/share/nvim/mason/bin
set PATH $PATH /Users/almagest/.local/fasmg/source/macos/x64
set PATH $PATH /usr/local/opt/libtool/libexec/gnubin
set --universal -x GOPATH ~/.go
set PATH $PATH $GOROOT/bin:$GOPATH/bin
set GOLSPPATH $GOPATH/src/github.com/ajaymt/golsp
set DYLD_LIBRARY_PATH $DYLD_LIBRARY_PATH /Users/almagest/.rustup/toolchains/stable-x86_64-apple-darwin/lib
set DYLD_LIBRARY_PATH $DYLD_LIBRARY_PATH /Users/almagest/.local/gnu/lib
set CPATH $CPATH /opt/homebrew/include

# set -gx LDFLAGS "-L/usr/local/opt/llvm/lib"
# set -gx CPPFLAGS "-I/usr/local/opt/llvm/include"
set VCPKG_ROOT $HOME/vcpkg
fish_add_path /usr/local/opt/llvm/bin

set -gx LDFLAGS "-L/usr/local/opt/icu4c/lib"
set -gx CPPFLAGS "-I/usr/local/opt/icu4c/include"
set -gx PKG_CONFIG_PATH "/usr/local/opt/icu4c/lib/pkgconfig"
# fish_add_path /usr/local/opt/icu4c/bin
# fish_add_path /usr/local/opt/icu4c/sbin

function v
    nvim $argv
end

function h
    hx $argv
end

function t
    tmux $argv
end

function ls
    exa $argv
end

function l
    exa -lhGa $argv
end

function oldrm
    /bin/rm $argv
end

function rm
    xilo $argv
end

function oldls
    /bin/ls $argv
end

function vimcfg
    nvim ~/.config/nvim/init.vim
end

function fishcfg
    nvim ~/.config/fish/config.fish
end

function hxcfg
    nvim ~/.config/helix/config.toml
end

function cmakeinit
    $EDITOR CMakeLists.txt
end

function llvmpath
    set -gx LDFLAGS "-L/usr/local/opt/llvm/lib"
    set -gx CPPFLAGS "-I/usr/local/opt/llvm/include"
end

function matlab
    /Applications/MATLAB_R2023b.app/bin/matlab -nodesktop
end

function c
    clear
end

function lg
    lazygit $argv
end

function view
    nvim -R $argv
end

function reloadfish
    source ~/.config/fish/config.fish
end

function getmusic
    youtube-dl -x --audio-format flac --output "%(title)s.%(ext)s" $argv
end

function gitall
    git add . && git commit -m $argv && git push origin master
end

function getaedif
    wget https://github.com/e0328eric/aedif/raw/main/aedif.h
end

function s
    ls $argv
end

function shtobat
    npx bash-converter $argv
end

function hakwon
    cd ~/pCloudDrive/AlmaFiles/TeX_Documents/Hakwon
end

function minireport
    cd ~/pCloudDrive/AlmaFiles/TeX_Documents/Mini_Report
end

function notetaking
    cd ~/pCloudDrive/AlmaFiles/TeX_Documents/NoteTaking
end

function homework
    cd ~/pCloudDrive/AlmaFiles/TeX_Documents/Homework
end

function lecturenote
    cd ~/pCloudDrive/AlmaFiles/TeX_Documents/Lecture_Note
end

function mathbook
    cd ~/pCloudDrive/AlmaFiles/Math
end

function teachingf
    cd ~/pCloudDrive/AlmaFiles/TeX_Documents/TF
end

function cfmtcp
    cp ~/Github/arch-almagest/format/.clang-format .
end

fish_add_path /usr/local/opt/bison/bin

# opam configuration
source $HOME/.opam/opam-init/init.fish >/dev/null 2>/dev/null; or true

set -gx WASMTIME_HOME "$HOME/.wasmtime"

string match -r ".wasmtime" "$PATH" >/dev/null; or set -gx PATH "$WASMTIME_HOME/bin" $PATH

# bun
set --export BUN_INSTALL "$HOME/.bun"
set --export PATH $BUN_INSTALL/bin $PATH

#          ╭──────────────────────────────────────────────────────────╮
#          │                           nnn                            │
#          ╰──────────────────────────────────────────────────────────╯
# color
set BLK "04"
set CHR "04"
set DIR "04"
set EXE "00"
set REG "00"
set HARDLINK "00"
set SYMLINK "06"
set MISSING "00"
set ORPHAN "01"
set FIFO "0F"
set SOCK "0F"
set OTHER "02"
set -gx NNN_FCOLORS "$BLK$CHR$DIR$EXE$REG$HARDLINK$SYMLINK$MISSING$ORPHAN$FIFO$SOCK$OTHER"

# plugins
set -gx NNN_FIFO "/tmp/nnn.fifo nnn"
set -gx NNN_PLUG "f:finder;o:fzopen;p:mocq;d:diffs;t:nmount;v:preview-tui"

#          ╭──────────────────────────────────────────────────────────╮
#          │                          Ghcup                           │
#          ╰──────────────────────────────────────────────────────────╯
#set -q GHCUP_INSTALL_BASE_PREFIX[1]; or set GHCUP_INSTALL_BASE_PREFIX $HOME ; set -gx PATH $HOME/.cabal/bin /Users/almagest/.ghcup/bin $PATH # ghcup-env

set -q GHCUP_INSTALL_BASE_PREFIX[1]; or set GHCUP_INSTALL_BASE_PREFIX $HOME ; set -gx PATH $HOME/.cabal/bin $PATH /Users/almagest/.ghcup/bin # ghcup-env

#          ╭──────────────────────────────────────────────────────────╮
#          │                  Initialize oh-my-posh                   │
#          ╰──────────────────────────────────────────────────────────╯

oh-my-posh init fish --config "https://raw.githubusercontent.com/JanDeDobbeleer/oh-my-posh/refs/heads/main/themes/stelbent.minimal.omp.json" | source
