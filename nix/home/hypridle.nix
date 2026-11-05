{ pkgs, ... }:
let
  onACPower = "${pkgs.systemd}/bin/systemd-ac-power";
  screenOff = "hyprctl dispatch 'hl.dsp.dpms({ action = \"disable\" })'";
  screenOn = "hyprctl dispatch 'hl.dsp.dpms({ action = \"enable\" })'";
in
{
  services.hypridle = {
    enable = true;

    settings = {
      general = {
        lock_cmd = "pidof hyprlock || hyprlock";
        before_sleep_cmd = "loginctl lock-session";
        after_sleep_cmd = screenOn;
        ignore_dbus_inhibit = false;
      };

      listener = [
        # 30s: Turn off screen if locked, only on battery
        {
          timeout = 30;
          on-timeout = "${onACPower} || (pidof hyprlock && ${screenOff})";
          on-resume = "pidof hyprlock && ${screenOn}";
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
          on-timeout = screenOff;
          on-resume = screenOn;
        }
        # 2h: Suspend only on battery; never auto-suspend on AC power
        {
          timeout = 7200;
          on-timeout = "${onACPower} || systemctl suspend";
          on-resume = "notify-send \"Welcome back to your desktop!\"";
        }
      ];
    };
  };
}
