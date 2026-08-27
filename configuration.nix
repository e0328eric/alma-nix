{
  config,
  lib,
  pkgs,
  inputs,
 ...
}:
let
  nix_vars = import ./variables.nix;
  mainWm = nix_vars.mainWm or "niri";
  system = "x86_64-linux";
in
{
  imports = [
    ./hardware-configuration.nix
    inputs.honkai-railway-grub-theme.nixosModules.${system}.default
    #./nix/root/boot.nix
    ./nix/root/boot-honkai.nix
    ./nix/root/languages.nix
    ./nix/root/graphics.nix
    ./nix/root/fan.nix
    ./nix/root/fonts.nix
    ./nix/root/users.nix
    ./nix/root/bluetooth.nix
    ./nix/root/stylix.nix
    ./nix/root/services.nix
    ./nix/root/input.nix
    ./nix/root/python.nix
    ./nix/root/packages.nix
    ./nix/root/game.nix
    ./nix/root/gnome-keyring.nix
    ./nix/root/fhs
  ];

  # set permitions for /game directory
  systemd.tmpfiles.rules = [
    "d /game 0755 almagest users -"
  ];

  nix.settings = {
    builders-use-substitutes = true;
  };

  networking.hostName = "almanixos";
  networking.networkmanager.enable = true;
  networking.networkmanager.wifi.powersave = false;

  time.timeZone = "Asia/Seoul";

  # Enable RealtimeKit to allow PipeWire to acquire realtime priority
  security.rtkit.enable = true;

  programs.hyprland = lib.mkIf (mainWm == "hyprland") {
    enable = true;
    xwayland.enable = true;
    #package = inputs.hyprland.packages.${pkgs.system}.hyprland;
    #portalPackage = inputs.hyprland.packages.${pkgs.system}.xdg-desktop-portal-hyprland;
  };
  programs.niri = lib.mkIf (mainWm == "niri") {
    enable = true;
  };
  programs.mango = lib.mkIf (mainWm == "mango") {
    enable = true;
  };

  systemd.services."home-manager-almagest" = {
    wants = [ "network-online.target" ];
    after = [ "network-online.target" ];
  };
  services.upower.enable = true;

  # dconf
  programs.dconf.enable = true;

  # enable flake
  nix.settings.experimental-features = [
    "nix-command"
    "flakes"
  ];

  # enable to download vivaldi
  nixpkgs.config.allowUnfree = true;

  # Open ports in the firewall.
  networking.firewall.enable = true;
  networking.firewall.allowedTCPPorts = [
    5000
    5001
  ];
  networking.firewall.allowedUDPPorts = [
    5000
    5001
  ];

  # open ports for kdeconnect
  networking.firewall.allowedTCPPortRanges = [
    {
      from = 1714;
      to = 1764;
    }
  ];
  networking.firewall.allowedUDPPortRanges = [
    {
      from = 1714;
      to = 1764;
    }
  ];

  # enable to run AppImage
  programs.appimage = {
    enable = true;
    binfmt = true;
  };

  # set gtk theme to null to supress evaluation warning
  #gtk.gtk4.theme = null;

  system.stateVersion = "25.11"; # Did you read the comment?
}
