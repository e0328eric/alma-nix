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
  home.packages = with pkgs; [
    #inputs.awww.packages.${pkgs.stdenv.hostPlatform.system}.awww
    mako
    networkmanagerapplet
    mpv
    caja
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

  # xdg-desktop-portal.service has Requisite=graphical-session.target, so the
  # portal (and OBS screen capture) refuses to start unless something binds
  # graphical-session.target. Started from autostart.lua.
  systemd.user.targets.hyprland-session = {
    Unit = {
      Description = "Hyprland compositor session";
      Documentation = [ "man:systemd.special(7)" ];
      BindsTo = [ "graphical-session.target" ];
      Wants = [ "graphical-session-pre.target" ];
      After = [ "graphical-session-pre.target" ];
    };
  };

  xdg.portal = {
    enable = true;

    extraPortals = with pkgs; [
      xdg-desktop-portal-hyprland
      xdg-desktop-portal-gtk
    ];

    config.hyprland = {
      default = [
        "hyprland"
        "gtk"
      ];

      "org.freedesktop.impl.portal.ScreenCast" = [ "hyprland" ];
      "org.freedesktop.impl.portal.Screenshot" = [ "hyprland" ];
      "org.freedesktop.impl.portal.FileChooser" = [ "gtk" ];
    };
  };
}
