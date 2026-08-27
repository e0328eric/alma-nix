{ config, pkgs, ... }:
let
  binaries = [
    "chre"
    "scsh_hyprland"
    "scsh_niri"
    "zigup"
    "zls"
    "ae"
  ];
in
{
  home.file = builtins.listToAttrs (
    map (name: {
      name = "./.local/bin/${name}";
      value = {
        source = ./bin + "/${name}";
        executable = true;
      };
    }) binaries
  );
}
