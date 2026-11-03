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
    # The fish target injects base16-shell into /etc/fish/config.fish, which
    # repaints the terminal palette via OSC escapes and overrides Ghostty's theme.
    targets.fish.enable = false;
  };
}
