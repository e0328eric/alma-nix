{ pkgs }:
pkgs.stdenv.mkDerivation rec {
  pname = "comfyui-desktop-2";
  version = "0.4.5";
  src = pkgs.fetchurl {
    url = "https://dl.todesktop.com/241130tqe9q3y/linux/deb/x64";
    name = "comfyui-desktop-2.deb";
    sha256 = "sha256-fU3qT5+vjBWGD4OonIvcC+EXY695soVPC6kjx8Kl96c=";
  };
  nativeBuildInputs = with pkgs; [
    dpkg
    autoPatchelfHook
    makeWrapper
  ];
  buildInputs = with pkgs; [
    alsa-lib
    at-spi2-atk
    cairo
    cups
    dbus
    expat
    glib
    gtk3
    libdrm
    libGL
    libxkbcommon
    mesa
    nspr
    nss
    pango
    libX11
    libXcomposite
    libXdamage
    libXext
    libXfixes
    libXrandr
    libxcb
  ];
  unpackPhase = "dpkg -x $src .";
  installPhase = ''
    mkdir -p $out/bin $out/opt $out/share
    cp -r "opt/ComfyUI Desktop 2.0" "$out/opt/ComfyUI Desktop 2.0"
    cp -r usr/share/* $out/share/

    makeWrapper "$out/opt/ComfyUI Desktop 2.0/comfyui-desktop-2" $out/bin/comfyui-desktop-2 \
      --prefix LD_LIBRARY_PATH : "${pkgs.lib.makeLibraryPath buildInputs}"
  '';
}
