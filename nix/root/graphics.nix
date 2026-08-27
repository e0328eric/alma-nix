{ pkgs, ... }:
{
  # nvidia driver
  hardware.graphics = {
    enable = true;
    enable32Bit = true;
  };
  services.xserver.videoDrivers = [ "nvidia" ];

  hardware.nvidia.modesetting.enable = true; # for wayland
  hardware.nvidia.open = false;
  hardware.nvidia.prime = {
    offload = {
      enable = true;
      enableOffloadCmd = true;
    };
    # once nixos-hardware is used, this is unnecessary
    #  intelBusId = "PCI:0:2:0";
    #  nvidiaBusId = "PCI:1:0:0";
  };

  environment.systemPackages = with pkgs; [
    vulkan-tools
    vulkan-loader
  ];
}
