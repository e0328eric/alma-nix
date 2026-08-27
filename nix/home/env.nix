{ config, lib, ... }:
let
  home = config.home.homeDirectory;
in
{
  home.sessionVariables = {
    QT_IM_MODULE = "fcitx";
    XMODIFIERS = "@im=fcitx";
    SDL_IM_MODULE = "fcitx";
    GDK_SCALE = "1.0";
    GDK_DPI_SCALE = "0.8";
    HYPRCURSOR_SIZE = "32";
    XCURSOR_SIZE = "32";
    QT_CURSOR_SIZE = "32";
    GRIM_DEFAULT_DIR = "${home}/Documents/Screenshots";
    GTK_THEME = "Adwaita:dark";
    QT_STYLE_OVERRIDE = lib.mkForce "Adwaita-Dark";
    XDG_SESSION_TYPE = "wayland";
    XDG_SESSION_DESKTOP = "niri";
    SDL_VIDEODRIVER = "wayland";
    WLR_NO_HARDWARE_CURSORS = "1";
    LIBVA_DRIVER_NAME = "nvidia";
    __GLX_VENDOR_LIBRARY_NAME = "nvidia";
    ELECTRON_OZONE_PLATFORM_HINT = "auto";
    MOZ_DISABLE_RDD_SANDBOX = "1";
    MOZ_ENABLE_WAYLAND = "1";
  };
}
