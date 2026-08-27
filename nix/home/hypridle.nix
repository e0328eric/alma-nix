{ config, pkgs, ... }:
{
  services.hypridle = {
    enable = true;
    
    settings = {
      general = {
        lock_cmd = "pidof hyprlock || hyprlock";
        before_sleep_cmd = "loginctl lock-session";
        after_sleep_cmd = "hyprctl dispatch dpms on";
        ignore_dbus_inhibit = false;
      };

      listener = [
        # 30s: Turn off screen if locked
        {
          timeout = 30;
          on-timeout = "pidof hyprlock && hyprctl dispatch dpms off";
          on-resume = "pidof hyprlock && hyprctl dispatch dpms on";
        }
        # 5min: Warning
        {
          timeout = 300;
          on-timeout = "notify-send \"You are idle!\"";
          on-resume = "notify-send \"Welcome back!\"";
        }
        # 30min: Lock screen
        {
          timeout = 1800;
          on-timeout = "loginctl lock-session";
        }
        # 1h: Turn off screen
        {
          timeout = 3600;
          on-timeout = "hyprctl dispatch dpms off";
          on-resume = "hyprctl dispatch dpms on";
        }
        # 2h: Suspend
        {
          timeout = 7200;
          on-timeout = "systemctl suspend";
          on-resume = "notify-send \"Welcome back to your desktop!\"";
        }
      ];
    };
  };
}
