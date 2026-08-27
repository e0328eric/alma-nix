{ pkgs, inputs, ... }:
let
  vars = import ../../variables.nix;
  username = vars.username or "almagest";
in
{
  imports = [
    inputs.noctalia.homeModules.default
  ];

  stylix.targets.noctalia.enable = false;

  # configure options
  programs.noctalia = {
    enable = true;
    settings = ./noctalia-config.toml;
  };
}
