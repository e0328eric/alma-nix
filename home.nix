{
  config,
  pkgs,
  lib,
  ...
}:
let
  vars = import ./variables.nix;
  username = vars.username or "almagest";
  mainWm = vars.mainWm or "hyprland";

  dotFiles = "${config.home.homeDirectory}/.nixos/config";
  nixDir = "${config.home.homeDirectory}/.nixos";
  create_symlink = path: config.lib.file.mkOutOfStoreSymlink path;

  configs = {
    fish = "shell/fish";
    nushell = "shell/nushell";
    ghostty = "terminal/ghostty";
    kitty = "terminal/kitty";
    foot = "terminal/foot";
    waybar = "bar/waybar";
    vesti = "vesti";
    qutebrowser = "qutebrowser";
    ae = "ae";
  };
in
{
  home.username = "${username}";
  home.homeDirectory = "/home/${username}";
  home.stateVersion = "25.11";

  imports = [
    ./nix/home/env.nix
    ./nix/home/packages.nix
    ./nix/home/mime.nix
    ./nix/home/git.nix
    ./nix/home/exe.nix
    ./nix/home/desktops.nix
    ./nix/home/hypridle.nix
    ./nix/home/hyprlock.nix
    ./nix/home/noctalia.nix
  ]
  ++ lib.optionals (mainWm == "niri") [ ./nix/home/niri ]
  ++ lib.optionals (mainWm == "hyprland") [ ./nix/home/hypr ]
  ++ lib.optionals (mainWm == "mango") [ ./nix/home/mango ];

  # This path must be in your system PATH for rustup shims to work
  home.sessionPath = [ "$HOME/.cargo/bin" ];

  services.dunst.enable = true;
  services.vicinae = {
    enable = true;
  };

  # NOTE: home-manager does not delete symlink automatically in case of some
  # error. So if you want to remove symlink generated from here, you should
  # manually delete it.
  xdg.configFile =
    builtins.mapAttrs (name: subpath: {
      source = create_symlink "${dotFiles}/${subpath}";
      recursive = true;
    }) configs
    // {
      alma-wallpapers = {
        source = create_symlink "${nixDir}/wallpapers";
        recursive = true;
      };
      alma-scripts = {
        source = create_symlink "${nixDir}/nix/home/scripts";
        recursive = true;
      };
    };

  xdg.dataFile."icons/LilpaTheme" = {
    source = create_symlink "${nixDir}/nix/home/cursor/LilpaTheme";
    recursive = true;
  };

  xdg.dataFile."icons/LilpaTheme-Hyprcursor" = {
    source = "${
      pkgs.callPackage ./nix/home/cursor/hyprcursor.nix { }
    }/share/icons/LilpaTheme-Hyprcursor";
  };
}
