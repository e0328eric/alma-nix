{ pkgs, ... }:
{
  boot = {
    kernelPackages = pkgs.linuxPackages_latest;
    loader.grub = {
      enable = true;
      device = "nodev";
      efiSupport = true;
      useOSProber = true; # true for dual boot
      #gfxmodeEfi = "1920x1080";
    };
    loader.efi.canTouchEfiVariables = true;
    loader.timeout = 5;

    kernelParams = [
      "btusb.enable_autosuspend=n"
      "nvidia_drm.modeset=1"
      "nvidia.NVreg_PreserveVideoMemoryAllocations=1"
    ];
    extraModprobeConfig = ''
      options iwlwifi bt_coex_active=1 11n_disable=8
      options iwlmvm power_scheme=1
    '';
  };
  honkai-railway-grub-theme = {
      enable = true;
      # Remember
      # Theme name should have the same name as in assets/themes directory e.g. Dr.Ratio_cn is correct
      # 'theme' field is optional. Default theme is Acheron.
      theme = "SilverWolf-LV.999"; 
  };
}
