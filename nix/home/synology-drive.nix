{ pkgs }:
pkgs.stdenv.mkDerivation rec {
  pname = "synology-drive-client";
  version = "4.0.2-17889";
  src = pkgs.fetchurl {
    url = "https://global.synologydownload.com/download/Utility/SynologyDriveClient/4.0.2-17889/Ubuntu/Installer/synology-drive-client-17889.x86_64.deb";
    # If this hash fails, run: nix-prefetch-url <url>
    sha256 = "sha256-refsAzqYmKAr107D4HiJViBQE1Qa6QoOECtX+TPjSwU=";
  };
  nativeBuildInputs = [
    pkgs.autoPatchelfHook
    pkgs.qt5.wrapQtAppsHook
    pkgs.dpkg
  ];

  # Runtime dependencies required for the app to launch
  buildInputs = [
    pkgs.glibc
    pkgs.gtk3
    pkgs.pango
    pkgs.libxcb
  ];

  # Ignore optional missing plugins to prevent build errors
  autoPatchelfIgnoreMissingDeps = [
    "libnautilus-extension.so.1"
    "libnautilus-extension.so.4"
    "libQt5Pdf.so.5"
  ];
  unpackPhase = ''
    mkdir -p $out
    dpkg -x $src $out
    rm -rf $out/usr/lib/nautilus
    rm -rf $out/opt/Synology/SynologyDrive/package/cloudstation/icon-overlay
  '';

  installPhase = ''
    cp -av $out/usr/* $out
    rm -rf $out/usr
    runHook postInstall
  '';

  postInstall = ''
    substituteInPlace $out/bin/synology-drive --replace /opt $out/opt
  '';
}
