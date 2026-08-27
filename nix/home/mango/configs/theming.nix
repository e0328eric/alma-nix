{ config, pkgs, ... }:
let
  vars = import ./variables.nix { inherit config pkgs; };
  inherit (vars)
    cachylblue
    cachymblue
    ;
in
''
  # border settings
  borderpx    = 3              # Border width in pixels
  gappih	  = 7              # Horizontal inner gap (between windows).
  gappiv	  = 7              # Vertical inner gap.
  gappoh	  = 7              # Horizontal outer gap (between windows and screen edges).
  gappov	  = 7              # Vertical outer gap.
  bordercolor = ${cachymblue}
  focuscolor  = ${cachylblue}

  # cursor theme
  cursor_size  = 32
  cursor_theme = LilpaTheme
''
