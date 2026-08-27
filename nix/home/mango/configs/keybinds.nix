{
  config,
  pkgs,
  lib,
  ...
}:
let
  vars = import ./variables.nix { inherit config pkgs; };
  inherit (vars)
    terminal
    browser
    private_browser
    applauncher
    filemanager
    scripts
    ;

  prologue = [
    ''
      ## Keybind Syntax
      ## Key bindings follow this format:
      ## 
      ## 
      ## bind[flags]=MODIFIERS,KEY,COMMAND,PARAMETERS
      ## - Modifiers: SUPER, CTRL, ALT, SHIFT, NONE (combine with +).
      ## - Key: Key name (from xev or wev) or code (e.g., code:24 for q).
      ## - Flags
      ## l: Works even when screen is locked.
      ## s: Uses keysym instead of keycode.
      ## r: Triggers on key release instead of press.
      ## p: Pass key event to client.
      ##
      ## Touchpad Gestures
      ## gesturebind=MODIFIERS,DIRECTION,FINGERS,COMMAND,PARAMETERS
      ## - Direction: up, down, left, right
      ## - Fingers: 3 or 4
    ''
  ];
  appBindings = [
    ''
      # main app binds
      bind = SUPER           , Return, spawn_shell, ${terminal}
      bind = SUPER+SHIFT     , Return, spawn_shell, ${browser}
      bind = SUPER+CTRL+SHIFT, Return, spawn_shell, ${private_browser}
      bind = SUPER           , Space , spawn_shell, ${applauncher}
      bind = SUPER           , E     , spawn_shell, ${filemanager}
      bind = SUPER+SHIFT     , Q     , killclient
      bind = SUPER+SHIFT     , X     , spawn_shell, noctalia msg session lock
      
      bind = SUPER+SHIFT     , R     , reload_config
    ''
  ];
  screenshots = [
    ''
      # screenshots
      bind = SUPER+SHIFT     , P, spawn_shell, noctalia msg screenshot-region
    ''
  ];
  windowState = [
    ''
      # window state
      bind = SUPER      , F, togglefloating
      bind = SUPER+SHIFT, F, togglefullscreen
      bind = SUPER      , M, toggleglobal

      # Set specific layout
      bind = SUPER, T, setlayout, tile
      bind = SUPER, S, setlayout, scroller
    ''
  ];
  windowMovement = [
    ''
      # focus
      bind = SUPER, left , focusdir, left
      bind = SUPER, right, focusdir, right
      bind = SUPER, up   , focusdir, up
      bind = SUPER, down , focusdir, down

      # move/swap tiled window positions
      bind = SUPER+SHIFT, left , exchange_client, left
      bind = SUPER+SHIFT, right, exchange_client, right
      bind = SUPER+SHIFT, up   , exchange_client, up
      bind = SUPER+SHIFT, down , exchange_client, down

      # focus monitor
      bind = SUPER+CTRL, left , focusmon, left
      bind = SUPER+CTRL, right, focusmon, right
      bind = SUPER+CTRL, up   , focusmon, up
      bind = SUPER+CTRL, down , focusmon, down

      # move window into other monitor
      bind = SUPER+CTRL+SHIFT, left , tagmon, left
      bind = SUPER+CTRL+SHIFT, right, tagmon, right
      bind = SUPER+CTRL+SHIFT, up   , tagmon, up
      bind = SUPER+CTRL+SHIFT, down , tagmon, down
    ''
  ];
  workspaces = [
    ''
      # move workspaces
      bind = SUPER, 1, view, 1
      bind = SUPER, 2, view, 2
      bind = SUPER, 3, view, 3
      bind = SUPER, 4, view, 4
      bind = SUPER, 5, view, 5
      bind = SUPER, 6, view, 6
      bind = SUPER, 7, view, 7
      bind = SUPER, 8, view, 8
      bind = SUPER, 9, view, 9

      # place windows into workspaces
      bind = SUPER+SHIFT, 1, tag, 1
      bind = SUPER+SHIFT, 2, tag, 2
      bind = SUPER+SHIFT, 3, tag, 3
      bind = SUPER+SHIFT, 4, tag, 4
      bind = SUPER+SHIFT, 5, tag, 5
      bind = SUPER+SHIFT, 6, tag, 6
      bind = SUPER+SHIFT, 7, tag, 7
      bind = SUPER+SHIFT, 8, tag, 8
      bind = SUPER+SHIFT, 9, tag, 9

      bind = SUPER+SHIFT, Z, toggleoverview
    ''
  ];
  windowResize = [
    ''
      # floating resize only
      bind = SUPER+ALT+SHIFT, left , resizewin, (-10,0)
      bind = SUPER+ALT+SHIFT, right, resizewin, (+10,0)
      bind = SUPER+ALT+SHIFT, up   , resizewin, (0,-10)
      bind = SUPER+ALT+SHIFT, down , resizewin, (0,+10)

      # resize windows for scroller mode
      bind = SUPER+SHIFT,      S, switch_proportion_preset
      bind = SUPER+CTRL,       S, spawn_shell, mmsg -s -d set_proportion,0.75
      bind = SUPER+SHIFT+CTRL, S, spawn_shell, mmsg -s -d set_proportion,0.25
    ''
  ];
  mediaControl = [
    ''
      # media transport
      bind = NONE, XF86AudioPrev , spawn_shell, playerctl previous
      bind = NONE, XF86AudioNext , spawn_shell, playerctl next
      bind = NONE, XF86AudioPause, spawn_shell, playerctl play-pause
      bind = NONE, XF86AudioPlay , spawn_shell, playerctl play-pause
    ''
  ];
  mouseBind = [
    ''
      # mouse
      mousebind = SUPER      , btn_left, moveresize, curmove
      mousebind = SUPER+SHIFT, btn_left, moveresize, curresize
    ''
  ];
  touchpadBind = [
    ''
      # 3-finger: Window focus
      gesturebind = NONE, left , 3, viewtoright_have_client
      gesturebind = NONE, right, 3, viewtoleft_have_client
      gesturebind = SUPER, left , 3, tagtoright
      gesturebind = SUPER, right, 3, tagtoleft
      # gesturebind = NONE, up   , 3, focusdir,up
      # gesturebind = NONE, down , 3, focusdir,down

      # 4-finger: Workspace navigation
      gesturebind = NONE, left , 4, viewtoright_have_client
      gesturebind = NONE, right, 4, viewtoleft_have_client
      gesturebind = SUPER, left , 4, tagtoright
      gesturebind = SUPER, right, 4, tagtoleft
      gesturebind = NONE, up   , 4, toggleoverview
      gesturebind = NONE, down , 4, toggleoverview
    ''
  ];
  volumeBrightness = [
      ''
        # volume / brightness
        bind=NONE,XF86AudioRaiseVolume,spawn_shell,${scripts}/VolumeBrightnessPlain.sh volume_up
        bind=NONE,XF86AudioLowerVolume,spawn_shell,${scripts}/VolumeBrightnessPlain.sh volume_down
        bind=NONE,XF86AudioMute,spawn_shell,${scripts}/VolumeBrightnessPlain.sh volume_mute
        bind=NONE,XF86AudioMicMute,spawn_shell,wpctl set-mute @DEFAULT_AUDIO_SOURCE@ toggle
        bind=NONE,XF86MonBrightnessUp,spawn_shell,${scripts}/VolumeBrightnessPlain.sh brightness_up
        bind=NONE,XF86MonBrightnessDown,spawn_shell,${scripts}/VolumeBrightnessPlain.sh brightness_down
      ''
    ];
in
lib.concatStringsSep "\n" (
  builtins.concatLists [
    prologue
    appBindings
    screenshots
    windowState
    windowMovement
    workspaces
    windowResize
    volumeBrightness
    mediaControl
    mouseBind
    touchpadBind
  ]
)
