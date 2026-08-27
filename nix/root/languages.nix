{ pkgs, ... }:
{
  console.keyMap = "us";
  i18n.defaultLocale = "en_US.UTF-8";
  i18n.inputMethod = {
    enable = true;
    type = "fcitx5";
    fcitx5.addons = with pkgs; [
      fcitx5-gtk
      fcitx5-hangul
      fcitx5-anthy
      kdePackages.fcitx5-configtool
    ];
  };
}
