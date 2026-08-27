# Define a default editor
set -gx EDITOR nvim

set PATH $PATH ~/.local/bin
set PATH $PATH ~/.local/gcc/bin
set PATH $PATH ~/.local/farbfeld
set PATH $PATH ~/.cabal/bin
set PATH $PATH ~/.rustup/toolchains/stable-x86_64-unknown-linux-gnu/bin
set PATH $PATH ~/.rustup/toolchains/stable-x86_64-unknown-linux-gnu/lib
set PATH $PATH ~/.cargo/bin
set PATH $PATH ~/.nimble/bin
set PATH $PATH ~/.local/share/nvim/mason/bin
set --universal -x GOPATH ~/.go
set PATH $PATH $GOROOT/bin:$GOPATH/bin
set GOLSPPATH $GOPATH/src/github.com/ajaymt/golsp

function emptytrash
    rm -rf /home/almagest/.local/share/Trash
    rm -rf /home/almagest/.local/share/vifm/Trash
end

function vv
    command v $argv
end

function v
    nvim $argv
end

function h
    helix $argv
end

function t
    tmux $argv
end

function l
    ls -al $argv
end

function oldrm
    /usr/bin/env -S rm $argv
end

function rm
    chre rm $argv
end

function start
    xdg-open $argv
end

function ls
    eza --icons $argv
end

function o
    /usr/bin/xdg-open $argv &
end

function lsblk_serial
    lsblk -o NAME,SIZE,MODEL,SERIAL
end

function lsblk_uuid
    lsblk -o NAME,SIZE,TYPE,MOUNTPOINTS,UUID
end

function fishcfg
    nvim  ~/.config/fish/os/linux.fish
end

function nixpkg
    nvim $HOME/.nixos/nix/home/packages.nix
end

function nixrootpkg
    nvim $HOME/.nixos/nix/root/packages.nix
end

function nixnix
    sudo nixos-rebuild switch --flake ~/.nixos#almanixos
end

function nixupdate
    sudo nixos-rebuild switch --upgrade --flake ~/.nixos#almanixos
end

function flakeupdate
    cp $HOME/.nixos/flake.lock $HOME/.nixos/flake.lock.old
    sudo nix flake update
end

function nixgc
    nix-collect-garbage
end

function flatpakgame
    flatpak --installation=game $argv
end

alias xclip="/usr/bin/xclip -selection c"

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
    yt-dlp -x --audio-format flac --output "%(title)s.%(ext)s" $argv
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
    cd ~/pCloud/TeX_Documents/Hakwon
end

function minireport
    cd ~/pCloud/TeX_Documents/Mini_Report
end

function notetaking
    cd ~/pCloud/TeX_Documents/NoteTaking
end

function homework
    cd ~/pCloud/TeX_Documents/Homework
end

function lecturenote
    cd ~/pCloud/TeX_Documents/Lecture_Note
end

function mathbook
    cd ~/pCloud/Math
end

function teachingf
    cd ~/pCloud/TeX_Documents/TF
end

function kindergarten
    cd ~/pCloud/TeX_Documents/Kindergarten
end

function seminar
    cd ~/pCloud/TeX_Documents/Seminar
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

starship init fish | source
