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
    "exec = kanshi"
    "exec-once = awww-daemon --format xrgb"
    "exec-once = fcitx5 -d"
    "exec-once = vicinae server"
    "exec-once = nm-applet --indicator"
    "exec-once = /usr/lib/polkit-kde-authentication-agent-1 # Note: On NixOS this path might differ; check your Polkit package"
    "exec-once = synology-drive"
    "exec-once = wl-paste --type text --watch cliphist store"
    "exec-once = wl-paste --type image --watch cliphist store"
    "exec-once = systemctl --user import-environment"
    "exec-once = hash dbus-update-activation-environment 2>/dev/null"
    "exec-once = dbus-update-activation-environment --systemd"
    "exec-once = noctalia"
  ];
in
lib.concatStringsSep "\n" base + "\n"
