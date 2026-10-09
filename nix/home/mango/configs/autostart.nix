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
    "exec = fcitx5 -d"
    "exec = vicinae server"
    "exec = nm-applet --indicator"
    "exec = /usr/lib/polkit-kde-authentication-agent-1 # Note: On NixOS this path might differ; check your Polkit package"
    "exec = synology-drive"
    "exec = wl-paste --type text --watch cliphist store"
    "exec = wl-paste --type image --watch cliphist store"
    "exec = systemctl --user import-environment"
    "exec = hash dbus-update-activation-environment 2>/dev/null"
    "exec = dbus-update-activation-environment --systemd"
    "exec = noctalia"
  ];
in
lib.concatStringsSep "\n" base + "\n"
