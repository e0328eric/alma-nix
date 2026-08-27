{ config, pkgs }:
rec {
  mainmod = "SUPER";
  home = config.home.homeDirectory;
  hyprPath = "${home}/.config/hypr";
  scripts = "${home}/.config/alma-scripts";
  wallpapers = "${home}/.config/alma-wallpapers";

  # Programs
  filemanager = "nemo";
  applauncher = "vicinae toggle"; # Assuming vicinae is in your path
  #terminal = "kitty";
  terminal = "ghostty";
  browser = "brave --enable-features=UseOzonePlatform --ozone-platform=wayland --enable-wayland-ime";
  private_browser = "brave --enable-features=UseOzonePlatform --ozone-platform=wayland --enable-wayland-ime --incognito";
  #browser = "qutebrowser";
  #private_browser = "qutebrowser --target private-window";

  # Colors (CachyOS palette)
  cachylgreen = "0x82dcccff";
  cachymgreen = "0x00aa84ff";
  cachydgreen = "0x007d6fff";
  cachylblue = "0x01ccffff";
  cachymblue = "0x182545ff";
  cachydblue = "0x111826ff";
  cachywhite = "0xffffffff";
  cachygrey = "0xddddddff";
  cachygray = "0x798bb2ff";

  # https://nixos.org/manual/nixpkgs/unstable/#chap-trivial-builders
  wallpaperSuffler = pkgs.runCommandCC "wallpaperSuffler" { } ''
    mkdir -p $out/bin
    $CC -O2 ${../../scripts/wallpaper.c} -DMANGO -o $out/bin/wallpaperSuffler
  '';

  # https://nixos.org/manual/nixpkgs/unstable/#chap-trivial-builders
  eens = pkgs.runCommandCC "eens" { } ''
    mkdir -p $out/bin
    $CXX -std=c++20 -O2 ${../../scripts/eens.cc} -o $out/bin/eens
  '';
}
