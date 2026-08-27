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
        settings.main = {
          capslock = "esc";
          esc = "capslock";
          rightshift = "\\";
        };
      };
    };
  };
}
