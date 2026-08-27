{
  config,
  pkgs,
  lib,
  ...
}:
let
  home = config.home.homeDirectory;
  scripts = "${home}/.config/alma-scripts";
  wallpapers_path = "${home}/.config/alma-wallpapers";
  wallpaper = "${wallpapers_path}/columbina-moonlit-requiem.png";

  # colors
  background = "rgba(17,17,24, 1)";
  foreground = "rgba(215,244,255, 1)";
  color0 = "rgba(57,57,64, 1)";
  color1 = "rgba(7,15,46, 1)";
  color2 = "rgba(21,47,222, 1)";
  color3 = "rgba(104,103,123, 1)";
  color4 = "rgba(68,136,253, 1)";
  color5 = "rgba(198,193,213, 1)";
  color6 = "rgba(142,224,255, 1)";
  color7 = "rgba(190,231,247, 1)";
  color8 = "rgba(133,162,173, 1)";
  color9 = "rgba(7,15,46, 1)";
  color10 = "rgba(21,47,222, 1)";
  color11 = "rgba(104,103,123, 1)";
  color12 = "rgba(68,136,253, 1)";
  color13 = "rgba(198,193,213, 1)";
  color14 = "rgba(142,224,255, 1)";
  color15 = "rgba(190,231,247, 1)";
in
{
  programs.hyprlock = {
    enable = true;

    settings = {
      # General settings
      general = {
        grace = 1;
      };

      # Backgrounds
      background = lib.mkForce [
        {
          monitor = "";
          path = "${wallpaper}";

          # Blur settings
          blur_size = 5;
          blur_passes = 1;
          noise = 0.0117;
          contrast = 1.3000;
          brightness = 0.8000;
          vibrancy = 0.2100;
          vibrancy_darkness = 0.0;
        }
      ];

      # Input Field
      input-field = lib.mkForce [
        {
          monitor = "";
          size = "250, 50";
          outline_thickness = 3;
          dots_size = 0.33;
          dots_spacing = 0.15;
          dots_center = true;
          outer_color = "${color5}";
          inner_color = "${color0}";
          font_color = "${color12}";
          fade_on_empty = true;
          placeholder_text = "<i>Password...</i>";
          hide_input = false;

          position = "0, 200";
          halign = "center";
          valign = "bottom";
        }
      ];

      # Labels
      label = [
        # Date
        {
          monitor = "";
          text = "cmd[update:18000000] echo \"<b> \"$(date +'%A, %-d %B %Y')\" </b>\"";
          color = "${color5}";
          font_size = 40;
          font_family = "JetBrains Mono Nerd Font Mono ExtraBold";
          position = "0, -100";
          halign = "center";
          valign = "top";
        }
        # Time
        {
          monitor = "";
          text = "cmd[update:1000] echo -e \"$(date +\"%H:%M:%S\")\"";
          color = "${color6}";
          font_size = 100;
          font_family = "JetBrains Mono Nerd Font Mono ExtraBold";
          position = "0, -200";
          halign = "center";
          valign = "top";
        }
        # User
        {
          monitor = "";
          text = "   $USER";
          color = "${color12}";
          font_size = 18;
          font_family = "Inter Display Medium";
          position = "0, 100";
          halign = "center";
          valign = "bottom";
        }
        # Uptime
        {
          monitor = "";
          text = "cmd[update:60000] echo \"<b> \"$(uptime -p || ${scripts}/UptimeNixOS.sh)\" </b>\"";
          color = "${color12}";
          font_size = 24;
          font_family = "JetBrains Mono Nerd Font Mono ExtraBold";
          position = "0, 0";
          halign = "right";
          valign = "bottom";
        }
        # Weather
        {
          monitor = "";
          text = "cmd[update:3600000] [ -f ${home}/.cache/.weather_cache ] && cat  ${home}/.cache/.weather_cache";
          color = "${color12}";
          font_size = 24;
          font_family = "JetBrains Mono Nerd Font Mono ExtraBold";
          position = "50, 0";
          halign = "left";
          valign = "bottom";
        }
      ];
    };
  };
}
