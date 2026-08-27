{ config, pkgs, ... }:
{
  fonts.packages = with pkgs; [
    nanum
    nanum-gothic-coding
    noto-fonts-cjk-sans
    noto-fonts-cjk-serif
  ];

  fonts.fontconfig = {
    defaultFonts = {
      serif = [ "Noto Serif CJK KR" "DejaVu Serif" ];
      sansSerif = [ "Noto Sans CJK KR" "DejaVu Sans" ];
      monospace = [ "Noto Sans Mono CJK KR" "DejaVu Sans Mono" ];
    };
  };
}
