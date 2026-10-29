{ pkgs, ... }:
{
  # Run emacs as a daemon so that emacsclient opens instantly.
  services.emacs = {
    enable = true;
    package = pkgs.emacs-pgtk;
    # pgtk needs WAYLAND_DISPLAY, so wait for the compositor's session target
    # instead of starting at login.
    startWithUserSession = "graphical";
    # Adds an "Emacs Client" desktop entry that runs `emacsclient -c`.
    client.enable = true;
  };

  # Swap Esc and Meta only while an Emacs window is focused. keyd already
  # turns CapsLock into Esc (nix/root/input.nix); inside Emacs that key becomes
  # a held Alt (= Emacs Meta) and Alt becomes Esc. keyd's "meta" layer is
  # Super, so the layer has to be "alt".
  xdg.configFile."keyd/app.conf".text = ''
    [emacs]
    capslock = layer(alt)
    leftalt = esc
  '';

  systemd.user.services.keyd-application-mapper = {
    Unit = {
      Description = "keyd per-application key remapping";
      PartOf = [ "graphical-session.target" ];
      After = [ "graphical-session.target" ];
    };
    Service = {
      ExecStart = "${pkgs.keyd}/bin/keyd-application-mapper";
      # Retry until WAYLAND_DISPLAY has been imported into the user manager.
      Restart = "on-failure";
      RestartSec = 3;
    };
    Install.WantedBy = [ "graphical-session.target" ];
  };
}
