{ pkgs, ... }:
{
  stylix = {
    enable = true;
    # the list of which
    # https://github.com/tinted-theming/schemes/tree/spec-0.11/base16
    #base16Scheme = "${pkgs.base16-schemes}/share/themes/oxocarbon-dark.yaml";
    #base16Scheme = "${pkgs.base16-schemes}/share/themes/moonlight.yaml";
    base16Scheme = "${pkgs.base16-schemes}/share/themes/catppuccin-mocha.yaml";
    image = ../../wallpapers/columbina-moonlit-requiem.png;
    polarity = "dark"; # Forcing dark mode
    targets.grub.enable = false;
  };
}
