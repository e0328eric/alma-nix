{
  lib,
  cmake,
  libGL,
  hyprland,
  hyprlandPlugins,
  src,
}:

# Built against nixpkgs' hyprland (the one programs.hyprland runs) instead of
# the Hyprland pinned in Hypr3D's own flake, so the plugin ABI matches.
hyprlandPlugins.mkHyprlandPlugin {
  pluginName = "hypr3d";
  version = "0.5.0+${src.shortRev or "dirty"}";
  inherit src;

  nativeBuildInputs = [ cmake ];
  buildInputs = [ libGL ];

  cmakeFlags = [
    "-DHYPRLAND_HEADERS=${hyprland.dev}"
    "-DCMAKE_BUILD_TYPE=Release"
  ];

  # Upstream CMake has no install rules.
  installPhase = ''
    runHook preInstall
    install -Dm755 hypr3d.so $out/lib/hypr3d.so
    runHook postInstall
  '';

  meta = {
    homepage = "https://github.com/samine825/Hypr3D";
    description = "Hyprland plugin that turns your workspace into a walkable 3D space";
    license = lib.licenses.mit;
    platforms = lib.platforms.linux;
  };
}
