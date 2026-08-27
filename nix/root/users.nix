{ pkgs, ... }:
let
  vars = import ../../variables.nix;
  username = vars.username or "almagest";
  shellName = vars.shell or "nushell";
  userShell = if shellName == "nushell" then pkgs.nushell else pkgs.fish; # if shellName == "fish"
in
{
  programs.fish.enable = true;
  users.users.${username} = {
    isNormalUser = true;
    extraGroups = [
      "wheel" # Enable ‘sudo’ for the user.
      "docker"
    ];
    packages = with pkgs; [
      tree
    ];
    shell = userShell;
  };
}
