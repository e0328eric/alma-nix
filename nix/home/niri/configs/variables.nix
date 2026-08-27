{ config, pkgs }:
rec {
  mainmod = "SUPER";
  home = config.home.homeDirectory;
  hyprPath = "${home}/.config/hypr";
  scripts = "${home}/.config/alma-scripts";
  wallpapers = "${home}/.config/alma-wallpapers";

  # Programs
  filemanager = "nemo";
  applauncher = ''vicinae" "toggle''; # Assuming vicinae is in your path
  #terminal = "kitty";
  terminal = "ghostty";
  browser = ''brave" "--enable-features=UseOzonePlatform" "--ozone-platform=wayland" "--enable-wayland-ime'';
  private_browser = ''brave" "--enable-features=UseOzonePlatform" "--ozone-platform=wayland" "--enable-wayland-ime" "--incognito'';

  # Colors (CachyOS palette)
  cachylgreen = "#82dccc";
  cachymgreen = "#00aa84";
  cachydgreen = "#007d6f";
  cachylblue = "#01ccff";
  cachymblue = "#182545";
  cachydblue = "#111826";
  cachywhite = "#ffffff";
  cachygrey = "#dddddd";
  cachygray = "#798bb2";

  # https://nixos.org/manual/nixpkgs/unstable/#chap-trivial-builders
  wallpaperSuffler = pkgs.runCommandCC "wallpaperSuffler" { } ''
    mkdir -p $out/bin
    $CC -O2 ${../../scripts/wallpaper.c} -DNIRI -o $out/bin/wallpaperSuffler
  '';
}
