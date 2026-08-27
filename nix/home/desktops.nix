{ pkgs, ... }:
{
  xdg.desktopEntries = {
    signal-desktop = {
      name = "Signal";
      genericName = "Private Messenger";
      exec = "${pkgs.signal-desktop}/bin/signal-desktop %U";
      terminal = false;
      categories = [ "Network" "Chat" ];
      icon = "signal-desktop";
      mimeType = [ 
        "x-scheme-handler/signal-captcha"
        "x-scheme-handler/signal-group"
        "x-scheme-handler/signal-private-group" 
      ];
    };

    pavucontrol = {
      name = "Pavucontrol";
      genericName = "Pavucontrol";
      exec = "${pkgs.pavucontrol}/bin/pavucontrol %U";
      terminal = false;
    };

    nemo = {
      name = "Nemo";
      genericName = "Nemo File Manager";
      exec = "${pkgs.nemo}/bin/nemo %U";
      icon = "nemo";
      terminal = false;
    };
  };
}
