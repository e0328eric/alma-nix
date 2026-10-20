{ pkgs }:
let
  runtimePackages =
    pkgs: with pkgs; [
      glibc
      stdenv.cc.cc.lib
      icu78
      fontconfig
      harfbuzz
      freetype
      graphite2
      libpng
      openssl
      zlib
    ];
  libs = pkgs.lib.makeLibraryPath (runtimePackages pkgs);
  vesti = pkgs.runCommand "vesti-unwrapped" { nativeBuildInputs = [ pkgs.patchelf ]; } ''
    install -Dm755 ${./bin/vesti} "$out/bin/vesti"
    install -Dm755 ${./bin/libvesti_tectonic_x86_64_gnu.so} "$out/bin/libvesti_tectonic_x86_64_gnu.so"

    # The bundled executable can refer to a glibc from an older NixOS generation.
    # Patch a copy and keep Tectonic beside it so both use this package set.
    patchelf \
      --set-interpreter ${pkgs.stdenv.cc.bintools.dynamicLinker} \
      --set-rpath '${libs}:$ORIGIN' \
      "$out/bin/vesti"
  '';
in
pkgs.buildFHSEnv {
  name = "vesti";
  targetPkgs = runtimePackages;
  runScript = pkgs.writeShellScript "vesti-wrapper" ''
    # Tectonic is stripped; override its embedded library paths without patching it.
    export LD_LIBRARY_PATH="${libs}:${vesti}/bin''${LD_LIBRARY_PATH:+:$LD_LIBRARY_PATH}"
    exec "${vesti}/bin/vesti" "$@"
  '';
}
