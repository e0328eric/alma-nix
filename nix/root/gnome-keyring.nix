{ config, pkgs, ... }:
{
  services.gnome.gnome-keyring.enable = true;
  security.pam.services.login.enableGnomeKeyring = true;
  security.pam.services.sddm.enableGnomeKeyring = true;
  environment.systemPackages = with pkgs; [
    seahorse
  ];
}
