{ pkgs }:
let
  libs = pkgs.lib.makeLibraryPath (
    with pkgs;
    [
      stdenv.cc.cc.lib
      icu76
      fontconfig
      harfbuzz
      freetype
      graphite2
      libpng
      openssl
      zlib
    ]
  );
in
pkgs.buildFHSEnv {
  name = "vesti";
  targetPkgs =
    pkgs:
    (with pkgs; [
      stdenv.cc.cc.lib
      icu78
      fontconfig
      harfbuzz
      freetype
      graphite2
      libpng
      openssl
      zlib
    ]);
  runScript = pkgs.writeScript "vesti-wrapper" ''
    #!/bin/sh
    export LD_LIBRARY_PATH="${libs}:$HOME/.nixos/nix/home/bin:$LD_LIBRARY_PATH"
    exec "$HOME/.nixos/nix/home/bin/vesti" "$@"
  '';
}
