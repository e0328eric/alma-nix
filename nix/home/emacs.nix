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
}
