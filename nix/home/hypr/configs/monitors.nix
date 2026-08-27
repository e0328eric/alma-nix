{ ... }:
{
  services.kanshi = {
    enable = true;

    settings = [
      {
        profile.name = "home";
        profile.outputs = [
          {
            criteria = "eDP-1";
            status = "enable";
            mode = "3200x2000@165.001007Hz";
            position = "503,0";
            scale = 2.0;
          }
          {
            criteria = "BOE Display *";
            status = "enable";
            mode = "2560x1600@120Hz";
            position = "2103,0";
            scale = 1.6;
          }
        ];
      }
      {
        profile.name = "office";
        profile.outputs = [
          {
            criteria = "eDP-1";
            status = "enable";
            mode = "3200x2000@165.001007Hz";
            position = "503,0";
            scale = 2.0;
          }
          {
            criteria = "DP-3";
            status = "enable";
            mode = "2560x1600@60.0Hz";
            position = "2103,1000";
            scale = 1.6;
          }
          {
            criteria = "DP-4";
            status = "enable";
            mode = "2560x1600@60.0Hz";
            position = "2103,0";
            scale = 1.6;
          }
          {
            criteria = "Samsung Electric Company S24E450 *";
            status = "enable";
            mode = "1920x1080@60Hz";
            position = "3703,100";
            scale = 1.2;
          }
        ];
      }
      {
        profile.name = "office2";
        profile.outputs = [
          {
            criteria = "eDP-1";
            status = "enable";
            mode = "3200x2000@165.001007Hz";
            position = "503,0";
            scale = 2.0;
          }
          {
            criteria = "DP-4";
            status = "enable";
            mode = "2560x1600@60.0Hz";
            position = "2103,1000";
            scale = 1.6;
          }
          {
            criteria = "DP-5";
            status = "enable";
            mode = "2560x1600@60.0Hz";
            position = "2103,0";
            scale = 1.6;
          }
          {
            criteria = "Samsung Electric Company S24E450 *";
            status = "enable";
            mode = "1920x1080@60Hz";
            position = "3703,100";
            scale = 1.2;
          }
        ];
      }
      {
        profile.name = "office3";
        profile.outputs = [
          {
            criteria = "eDP-1";
            status = "enable";
            mode = "3200x2000@165.001007Hz";
            position = "503,0";
            scale = 2.0;
          }
          {
            criteria = "DP-6";
            status = "enable";
            mode = "2560x1600@60.0Hz";
            position = "2103,1000";
            scale = 1.6;
          }
          {
            criteria = "DP-7";
            status = "enable";
            mode = "2560x1600@60.0Hz";
            position = "2103,0";
            scale = 1.6;
          }
          {
            criteria = "Samsung Electric Company S24E450 *";
            status = "enable";
            mode = "1920x1080@60Hz";
            position = "3703,100";
            scale = 1.2;
          }
        ];
      }
      {
        profile.name = "office4";
        profile.outputs = [
          {
            criteria = "eDP-1";
            status = "enable";
            mode = "3200x2000@165.001007Hz";
            position = "503,0";
            scale = 2.0;
          }
          {
            criteria = "DP-3";
            status = "enable";
            mode = "2560x1600@60.0Hz";
            position = "2103,1000";
            scale = 1.6;
          }
          {
            criteria = "DP-5";
            status = "enable";
            mode = "2560x1600@60.0Hz";
            position = "2103,0";
            scale = 1.6;
          }
          {
            criteria = "Samsung Electric Company S24E450 *";
            status = "enable";
            mode = "1920x1080@60Hz";
            position = "3703,100";
            scale = 1.2;
          }
        ];
      }
      {
        profile.name = "laptop";
        profile.outputs = [
          {
            criteria = "eDP-1";
            status = "enable";
            mode = "3200x2000@165.001007Hz";
            position = "0,0";
            scale = 2.0;
          }
        ];
      }
    ];
  };
}
