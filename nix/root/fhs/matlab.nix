{ pkgs, ... }:
let
  vars = import ../../variable.nix;
  user = vars.username;
  matlabRoot = "/home/${user}/.local/MATLAB/R2025b";
in
{
  environment.systemPackages = [
    (pkgs.buildFHSEnv {
      name = "matlab-fhs";

      # Things proprietary installers commonly need
      targetPkgs =
        pkgs: with pkgs; [
          alsa-lib
          at-spi2-core
          atk
          bash
          cairo
          coreutils
          cups
          dbus
          eudev
          expat
          findutils
          fontconfig
          freetype
          gawk
          gdk-pixbuf
          glib
          glibc
          gnugrep
          gnused
          gtk2
          gtk3
          libGL
          libICE
          libSM
          libdrm
          libgbm
          libglvnd
          libuuid
          libx11
          libxcomposite
          libxcrypt
          libxcursor
          libxdamage
          libxext
          libxfixes
          libxft
          libxi
          libxinerama
          libxmu
          libxrandr
          libxrender
          libxt
          linux-pam
          mesa
          ncurses5
          nspr
          nss
          openssl
          pango
          stdenv.cc.cc
          wayland
          which
          zlib
        ];

      profile = ''
        export QT_QPA_PLATFORM=xcb
        export QT_QPA_PLATFORMTHEME=""
        export QT_STYLE_OVERRIDE=""
      '';

      # Start an interactive shell by default (so you can run ./install)
      runScript = "bash";
    })
  ];
}
