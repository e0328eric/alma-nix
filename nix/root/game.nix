{ pkgs, ... }:
{
  programs.steam = {
    enable = true;
    remotePlay.openFirewall = true;
    dedicatedServer.openFirewall = true;
    localNetworkGameTransfers.openFirewall = true;
    gamescopeSession.enable = true;
  };
  
  programs.gamemode.enable = true;

  environment.systemPackages = with pkgs; [
    mangohud
    lutris-git
    bbe
    bottles
    heroic
    protonplus-git
    goverlay
  ];

  # flatpak setting
  services.flatpak.enable = true;

  # anime games launcher
  #programs.anime-game-launcher.enable = true;     # genshin impact
  programs.anime-games-launcher.enable = true;
  programs.honkers-railway-launcher.enable = true; # honkai starrail
  #programs.honkers-launcher.enable = true;        # honkai 3rd
  #programs.sleepy-launcher.enable = true;         # zenless zone zero
}
