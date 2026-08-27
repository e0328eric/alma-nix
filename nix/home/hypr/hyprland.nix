# hyprland configuration file
# Original config submitted by https://github.com/SherLock707
#
# lib.mkForce is needed in some places because original hyprland config already
# defines the value, and we need to replace it.

{
  config,
  pkgs,
  lib,
  inputs,
  ...
}: # inputs comes from flake.nix inputs
let
  nixDir = "${config.home.homeDirectory}/.nixos";
  create_symlink = path: config.lib.file.mkOutOfStoreSymlink path;
in
{
  # disable hyprpaper
  services.hyprpaper.enable = lib.mkForce false;

  # Ensure necessary packages are installed
  home.packages =
    with pkgs;
    [
      #inputs.awww.packages.${pkgs.stdenv.hostPlatform.system}.awww
      mako
      networkmanagerapplet
      mpv
      nemo
      nemo-preview
      wl-clipboard
      hypridle
      hyprlock
      hyprshot
      kanshi
      playerctl
      grim
      grimblast
      #wallpaperSuffler
      inputs.noctalia.packages.${pkgs.stdenv.hostPlatform.system}.default
    ];
    
    xdg.configFile."hypr/hyprland.lua" = {
        source = create_symlink "${nixDir}/nix/home/hypr/configs/hyprland.lua";
        recursive = true;
    };
    xdg.configFile."hypr/keybindings.lua" = {
        source = create_symlink "${nixDir}/nix/home/hypr/configs/keybindings.lua";
        recursive = true;
    };
    xdg.configFile."hypr/variables.lua" = {
        source = create_symlink "${nixDir}/nix/home/hypr/configs/variables.lua";
        recursive = true;
    };
    xdg.configFile."hypr/autostart.lua" = {
        source = create_symlink "${nixDir}/nix/home/hypr/configs/autostart.lua";
        recursive = true;
    };
    xdg.configFile."hypr/env.lua" = {
        source = create_symlink "${nixDir}/nix/home/hypr/configs/env.lua";
        recursive = true;
    };
}
