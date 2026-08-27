{
  config,
  pkgs,
  lib,
  ...
}:
let
  vars = import ./variables.nix { inherit config pkgs; };
  inherit (vars)
    wallpapers
    ;
  base = [
    ''spawn-at-startup "awww-daemon" "--format" "xrgb"''
    ''spawn-at-startup "fcitx5" "-d"''
    ''spawn-at-startup "vicinae" "server"''
    ''spawn-at-startup "nm-applet" "--indicator"''
    ''spawn-at-startup "/usr/lib/polkit-kde-authentication-agent-1" // Note: On NixOS this path might differ; check your Polkit package''
    ''spawn-at-startup "synology-drive"''
    ''spawn-at-startup "wl-paste" "--type" "text" "--watch" "cliphist" "store"''
    ''spawn-at-startup "wl-paste" "--type" "image" "--watch" "cliphist" "store"''
    ''spawn-at-startup "systemctl" "--user" "import-environment"''
    ''spawn-at-startup "hash" "dbus-update-activation-environment" "2>/dev/null"''
    ''spawn-at-startup "dbus-update-activation-environment" "--systemd"''
    ''spawn-at-startup "hypridle"''
    ''spawn-at-startup "noctalia"''
  ];
in
lib.concatStringsSep "\n" base + "\n"
