{
  config,
  pkgs,
  lib,
  inputs,
  ...
}: # inputs comes from flake.nix inputs
let
  vars = import ./configs/variables.nix { inherit config pkgs; };
  inherit (vars)
    cachylblue
    cachymblue
    eens
    ;

  autostartModule = import ./configs/autostart.nix { inherit config pkgs lib; };
  keybindsModule = import ./configs/keybinds.nix { inherit config pkgs lib; };
  themingModule = import ./configs/theming.nix { inherit config pkgs; };
  inputModule = import ./configs/input.nix { };
  layoutModule = import ./configs/layout.nix { };
  tagrulesModule = import ./configs/tagrules.nix { };
  windowrulesModule = import ./configs/windowrules.nix { };
in
{
  imports = [
    ./configs/monitors.nix
  ];

  home.packages = with pkgs; [
    mako
    networkmanagerapplet
    mpv
    caja
    wl-clipboard
    playerctl
    grim
    wlr-randr
    kanshi
    eens
    #wallpaperSuffler # TODO: later update this for mango
    inputs.noctalia.packages.${pkgs.stdenv.hostPlatform.system}.default
  ];

  xdg.configFile."mango/config.conf".text = ''
    # Render XWayland apps at the monitor's native resolution.
    xwayland_ignore_scale = 1

    # Autostarts
    ${autostartModule}

    # Inputs
    ${inputModule}

    # Layout
    ${layoutModule}

    # Tag Rules
    ${tagrulesModule}

    # Themes
    ${themingModule}

    # Keybinds
    ${keybindsModule}

    # Window Rules
    ${windowrulesModule}

    animation_type_open = fade
    animation_type_close = fade
  '';
}
