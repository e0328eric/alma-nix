{ ... }:
{
  services = {
    libinput.enable = true; # touchpad driver
    libinput.touchpad = {
      tapping = true;
      tappingButtonMap = "lrm";
      clickMethod = "clickfinger";
    };

    #keyd
    keyd = {
      enable = true;
      keyboards.default = {
        ids = [ "*" ];
        settings = {
          main = {
            capslock = "esc";
            esc = "capslock";
            rightshift = "\\";
          };

          "control+alt".f12 = "toggle(game)";

          game = {
            capslock = "leftshift";
            f4 = "esc";
          };
        };
      };
    };
  };

  # keyd-application-mapper (per-app bindings, see nix/home/emacs.nix) talks to
  # keyd's socket, which is owned by the keyd group. keyd needs CAP_SETGID to
  # hand the socket to that group.
  users.groups.keyd = { };
  systemd.services.keyd.serviceConfig.CapabilityBoundingSet = [ "CAP_SETGID" ];
}
