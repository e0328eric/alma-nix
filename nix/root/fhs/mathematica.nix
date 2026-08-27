{ pkgs, ... }:
let
  vars = import ../../variable.nix;
  user = vars.username;
  matlabRoot = "/home/${user}/.local/MATLAB/R2025b";
in
{
  environment.systemPackages = [
    (pkgs.buildFHSEnv {
      name = "mathematica-fhs";

      # Things proprietary installers commonly need
      targetPkgs =
        pkgs: with pkgs; [
          bash
          coreutils
          glib
          glibc
          zlib
          openssl
          freetype
          fontconfig
          libX11
          libXext
          libXrender
          libXrandr
          libXcursor
          libXi
          libXt
          libXmu
          libXpm
          libXft
          libXinerama
          libICE
          libSM
          mesa
          gtk2
          gtk3
          nspr
          nss
          cups
          dbus
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
