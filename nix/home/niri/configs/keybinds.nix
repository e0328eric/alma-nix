{
  config,
  pkgs,
  lib,
  ...
}:
let
  nix_vars = import ../../../../variables.nix;
  username = nix_vars.username;

  vars = import ./variables.nix { inherit config pkgs; };
  inherit (vars)
    terminal
    browser
    private_browser
    applauncher
    filemanager
    scripts
    ;

  picture_dir = "/home/${username}/Pictures";

  base = [
    ''
      Mod+Return            { spawn "${terminal}"; }
      Mod+Shift+Return      { spawn "${browser}"; }
      Mod+Ctrl+Shift+Return { spawn "${private_browser}"; }
      Mod+Space             { spawn "${applauncher}"; }
      Mod+E                 { spawn "${filemanager}"; }
      Mod+Shift+X           { spawn "noctalia" "msg" "session" "lock"; }

      Mod+W        { spawn "noctalia" "msg" "screenshot-fullscreen" "pick"; }
      Mod+Shift+W  { spawn "noctalia" "msg" "screenshot-region"; }

      Mod+Shift+Q repeat=false { close-window; }

      Mod+Left  { focus-column-left; }
      Mod+Right { focus-column-right; }
      Mod+Up    { focus-window-up; }
      Mod+Down  { focus-window-down; }

      Mod+Shift+Left  { move-column-left; }
      Mod+Shift+Right { move-column-right; }
      Mod+Shift+Up    { move-window-up; }
      Mod+Shift+Down  { move-window-down; }

      Mod+Home      { focus-column-first; }
      Mod+End       { focus-column-last; }
      Mod+Ctrl+Home { move-column-to-first; }
      Mod+Ctrl+End  { move-column-to-last; }

      Mod+Ctrl+Left  { focus-monitor-left; }
      Mod+Ctrl+Right { focus-monitor-right; }
      Mod+Ctrl+Up    { focus-monitor-up; }
      Mod+Ctrl+Down  { focus-monitor-down; }

      Mod+Tab             { focus-monitor-next; }
      Mod+Shift+Tab       { move-window-to-monitor-next; }
      Mod+Ctrl+Tab        { focus-monitor-previous; }
      Mod+Shift+Ctrl+Tab  { move-window-to-monitor-previous; }

      Mod+Shift+Ctrl+Left  { move-column-to-monitor-left; }
      Mod+Shift+Ctrl+Right { move-column-to-monitor-right; }
      Mod+Shift+Ctrl+Up    { move-column-to-monitor-up; }
      Mod+Shift+Ctrl+Down  { move-column-to-monitor-down; }

      Mod+J       { focus-workspace-down; }
      Mod+K       { focus-workspace-up; }
      Mod+Ctrl+J  { move-column-to-workspace-down; }
      Mod+Ctrl+K  { move-column-to-workspace-up; }
      Mod+Shift+J { move-workspace-down; }
      Mod+Shift+K { move-workspace-up; }

      Mod+WheelScrollDown      cooldown-ms=150 { focus-workspace-down; }
      Mod+WheelScrollUp        cooldown-ms=150 { focus-workspace-up; }
      Mod+Ctrl+WheelScrollDown cooldown-ms=150 { move-column-to-workspace-down; }
      Mod+Ctrl+WheelScrollUp   cooldown-ms=150 { move-column-to-workspace-up; }

      Mod+WheelScrollRight      { focus-column-right; }
      Mod+WheelScrollLeft       { focus-column-left; }
      Mod+Ctrl+WheelScrollRight { move-column-right; }
      Mod+Ctrl+WheelScrollLeft  { move-column-left; }

      Mod+Shift+WheelScrollDown      { focus-column-right; }
      Mod+Shift+WheelScrollUp        { focus-column-left; }
      Mod+Ctrl+Shift+WheelScrollDown { move-column-right; }
      Mod+Ctrl+Shift+WheelScrollUp   { move-column-left; }

      Mod+1 { focus-workspace 1; }
      Mod+2 { focus-workspace 2; }
      Mod+3 { focus-workspace 3; }
      Mod+4 { focus-workspace 4; }
      Mod+5 { focus-workspace 5; }
      Mod+6 { focus-workspace 6; }
      Mod+7 { focus-workspace 7; }
      Mod+8 { focus-workspace 8; }
      Mod+9 { focus-workspace 9; }

      Mod+Shift+1 { move-column-to-workspace 1; }
      Mod+Shift+2 { move-column-to-workspace 2; }
      Mod+Shift+3 { move-column-to-workspace 3; }
      Mod+Shift+4 { move-column-to-workspace 4; }
      Mod+Shift+5 { move-column-to-workspace 5; }
      Mod+Shift+6 { move-column-to-workspace 6; }
      Mod+Shift+7 { move-column-to-workspace 7; }
      Mod+Shift+8 { move-column-to-workspace 8; }
      Mod+Shift+9 { move-column-to-workspace 9; }

      Mod+BracketLeft  { consume-or-expel-window-left; }
      Mod+BracketRight { consume-or-expel-window-right; }
      Mod+Period { expel-window-from-column; }

      Mod+T { toggle-window-floating; }

      Mod+A             { switch-preset-column-width; }
      Mod+Shift+A       { switch-preset-window-height; }
      Mod+Ctrl+A        { reset-window-height; }
      Mod+Shift+S       { maximize-column; }
      Mod+Shift+F       { fullscreen-window; }
      Mod+Ctrl+F        { maximize-window-to-edges; }
      Mod+Shift+Ctrl+F  { expand-column-to-available-width; }
      Mod+Ctrl+C        { center-column; }

      Mod+Minus { set-column-width "-10%"; }
      Mod+Equal { set-column-width "+10%"; }
      Mod+Shift+Minus { set-window-height "-10%"; }
      Mod+Shift+Equal { set-window-height "+10%"; }

      XF86AudioPrev  allow-when-locked=true { spawn "playerctl" "previous"; }
      XF86AudioNext  allow-when-locked=true { spawn "playerctl" "next"; }
      XF86AudioPause allow-when-locked=true { spawn "playerctl" "play-pause"; }
      XF86AudioPlay  allow-when-locked=true { spawn "playerctl" "play-pause"; }
    ''
  ];

  VolumeBrightness = [
    ''
      XF86AudioRaiseVolume {
          spawn "${scripts}/VolumeBrightnessPlain.sh" "volume_up";
      }
      XF86AudioLowerVolume {
          spawn "${scripts}/VolumeBrightnessPlain.sh" "volume_down";
      }
      XF86AudioMute {
          spawn "${scripts}/VolumeBrightnessPlain.sh" "volume_mute";
      }
      XF86AudioMicMute {
          spawn "wpctl" "set-mute" "@DEFAULT_AUDIO_SOURCE@" "toggle";
      }
      XF86MonBrightnessUp allow-when-locked=true {
          spawn "${scripts}/VolumeBrightnessPlain.sh" "brightness_up";
      }
      XF86MonBrightnessDown allow-when-locked=true {
          spawn "${scripts}/VolumeBrightnessPlain.sh" "brightness_down";
      }
    ''
  ];
in
lib.concatStringsSep "\n" ([ "binds {" ] ++ base ++ VolumeBrightness ++ [ "\n}" ])
