{ pkgs }:
pkgs.stdenv.mkDerivation {
  pname = "codex-desktop";
  version = "26.908.40834";

  src = pkgs.fetchurl {
    url = "https://persistent.oaistatic.com/codex-app-prod/linux/deb/latest/chatgpt_amd64.deb";
    # This URL tracks latest; update the version and hash together when upgrading.
    # Get the new hash with: nix-prefetch-url <url>
    sha256 = "sha256-2je457zvquoBnEeMrL5sc+4d3RXg4euzx+8KQt2BisI=";
  };

  nativeBuildInputs = with pkgs; [
    autoPatchelfHook
    dpkg
    makeWrapper
    wrapGAppsHook3
  ];

  buildInputs = with pkgs; [
    alsa-lib
    at-spi2-atk
    at-spi2-core
    cairo
    cups
    dbus
    expat
    gdk-pixbuf
    glib
    gtk3
    libgbm
    libusb1
    libX11
    libXcomposite
    libXdamage
    libXext
    libXfixes
    libXrandr
    libxcb
    libxkbcommon
    nspr
    nss
    pango
    stdenv.cc.cc.lib
    systemd
  ];

  # Libraries loaded dynamically by Chromium and its native modules.
  runtimeDependencies = with pkgs; [
    (lib.getLib libGL)
    (lib.getLib libnotify)
    (lib.getLib libpulseaudio)
    (lib.getLib libsecret)
  ];

  # ANGLE also loads graphics libraries dynamically from shared objects.
  appendRunpaths = [
    "${builtins.placeholder "out"}/lib/chatgpt"
    (pkgs.lib.makeLibraryPath [
      pkgs.libGL
      pkgs.pciutils
    ])
  ];

  dontConfigure = true;
  dontBuild = true;
  dontStrip = true;
  dontWrapGApps = true;

  unpackPhase = ''
    runHook preUnpack
    dpkg -x "$src" .
    runHook postUnpack
  '';

  installPhase = ''
    runHook preInstall

    mkdir -p "$out/bin"
    cp -a usr/lib usr/share "$out/"
    rm -rf "$out/share/lintian"

    # Use GTK integration and the glibc native modules on NixOS.
    rm "$out/lib/chatgpt/libqt5_shim.so" "$out/lib/chatgpt/libqt6_shim.so"
    find "$out/lib/chatgpt/resources" -path '*/prebuilds/*' -name '*musl*' \
      -prune -exec rm -rf {} +

    # Use NixOS's Vulkan loader so it can discover the system graphics drivers.
    rm "$out/lib/chatgpt/libvulkan.so.1"
    ln -s "${pkgs.lib.getLib pkgs.vulkan-loader}/lib/libvulkan.so.1" \
      "$out/lib/chatgpt/libvulkan.so.1"

    substituteInPlace "$out/share/applications/chatgpt.desktop" \
      --replace-fail "Exec=chatgpt" "Exec=$out/bin/chatgpt"

    runHook postInstall
  '';

  preFixup = ''
    makeWrapper "$out/lib/chatgpt/ChatGPT" "$out/bin/chatgpt" \
      "''${gappsWrapperArgs[@]}" \
      --suffix PATH : "${
        pkgs.lib.makeBinPath [
          pkgs.glib
          pkgs.xdg-utils
        ]
      }"

    # Keep the existing `codex` CLI available alongside the desktop app.
    ln -s chatgpt "$out/bin/codex-desktop"
  '';

  meta = with pkgs.lib; {
    description = "Codex desktop app from OpenAI's ChatGPT Debian package";
    homepage = "https://developers.openai.com/codex/app";
    license = licenses.unfree;
    sourceProvenance = [ sourceTypes.binaryNativeCode ];
    platforms = [ "x86_64-linux" ];
    mainProgram = "codex-desktop";
  };
}
