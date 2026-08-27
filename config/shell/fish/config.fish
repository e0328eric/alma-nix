switch (uname)
    case Linux
        source $HOME/.config/fish/os/linux.fish
    case Darwin
        source $HOME/.config/fish/os/darwin.fish
    case Windows
        source ./os/windows.fish
end
