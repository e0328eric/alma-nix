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
  border_px            = 3              # Border width in pixels
  gap_inner_horizontal = 7              # Horizontal inner gap (between windows).
  gap_inner_vertical   = 7              # Vertical inner gap.
  gap_outer_horizontal = 7              # Horizontal outer gap (between windows and screen edges).
  gap_outer_vertical   = 7              # Vertical outer gap.
  border_color = ${cachymblue}
  focus_color  = ${cachylblue}

  # cursor theme
  cursor_size  = 32
  cursor_theme = LilpaTheme
''
