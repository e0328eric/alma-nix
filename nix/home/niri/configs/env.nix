{ config, pkgs, ... }:
let
  vars = import ./variables.nix { inherit config pkgs; };
  inherit (vars)
    terminal
    ;
in
''
  environment {
    XDG_CURRENT_DESKTOP "niri"
    QT_QPA_PLATFORM "wayland;xcb"
    ELECTRON_OZONE_PLATFORM_HINT "auto"
    QT_QPA_PLATFORMTHEME "gtk3"
    QT_QPA_PLATFORMTHEME_QT6 "gtk3"
    TERMINAL "${terminal}"
  }

  cursor {
      xcursor-theme "LilpaTheme"
      xcursor-size 32
  }
''
