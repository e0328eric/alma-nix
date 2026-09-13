{ pkgs, ... }:
let
  fingerprintFirst = {
    fprintAuth = true;
    unixAuth = true;
    # NixOS puts fprintd before password authentication. A failed scan or
    # timeout falls through to pam_unix; a successful scan is enough to log in.
    rules.auth.fprintd = {
      control = "sufficient";
      settings = {
        max-tries = 3;
        timeout = 10;
      };
    };
  };
in
{
  services = {
    printing.enable = true; # cups
    # disable pulseaudio
    pulseaudio.enable = false;
    pipewire = {
      enable = true;
      alsa.enable = true;
      alsa.support32Bit = true;
      pulse.enable = true;

      # Low latency configuration
      # this config solves glitching issue for bluetooth headset
      extraConfig.pipewire."92-low-latency" = {
        "context.properties" = {
          "default.clock.rate" = 48000;
          "default.clock.quantum" = 1024;
          "default.clock.min-quantum" = 512;
          "default.clock.max-quantum" = 2048;
        };
      };

      wireplumber.extraConfig = {
        "monitor.bluez.properties" = {
          "bluez5.enable-sbc-xq" = false;
          "bluez5.enable-msbc" = true;
          "bluez5.enable-hw-volume" = true;
          "bluez5.roles" = [
            "a2dp_sink"
            "a2dp_source"
            "hsp_hs"
            "hsp_ag"
            "hfp_hf"
            "hfp_ag"
          ];
        };
      };
    };

    blueman.enable = true; # gui bluetooth settings

    # fingerprint
    fprintd.enable = true;

    # printing
    avahi = {
      enable = true;
      nssmdns4 = true;
      openFirewall = true;
    };
    printing = {
      listenAddresses = [ "*:631" ];
      allowFrom = [ "all" ];
      browsing = true;
      defaultShared = true;
      openFirewall = true;
      drivers = [
        pkgs.samsung-unified-linux-driver
      ];
    };

    #sddm
    displayManager.sddm = {
      enable = true;
      wayland.enable = true;
      theme = "almagest-sddm";
      settings = {
        General = {
          InputMethod = "";
        };
        Theme = {
          Current = "almagest-sddm";
        };
      };
      # Since theme is likely Qt6, we should use the Qt6 version of SDDM to
      # ensure compatibility.
      package = pkgs.kdePackages.sddm;
      extraPackages = with pkgs.kdePackages; [
        qtmultimedia
        qtsvg
        qtvirtualkeyboard
      ];
    };
  };

  # SDDM delegates authentication to the login PAM stack.
  security.pam.services = {
    login = fingerprintFirst;
    sudo = fingerprintFirst;
    # Home Manager enables Hyprlock, but the PAM service must exist system-wide.
    hyprlock = { };
  };
}
