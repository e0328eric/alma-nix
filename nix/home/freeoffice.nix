{ pkgs, lib }:
let
  edition = "2024";
  version = "1234"; # latest confirmed Linux revision
  hash = "sha256-q5QUevkSxdh622ZMhwbO44HLJowpg0vwv9de7hdOUQQ=";

  archive = "freeoffice${edition}.tar.lzma"; # inner archive inside the tgz
  shortEdition = builtins.substring 2 2 edition; # "2024" -> "24"

  extraWrapperArgs = ''
    --set LD_PRELOAD "${pkgs.libredirect}/lib/libredirect.so" \
    --set NIX_REDIRECTS "/bin/ls=${pkgs.coreutils}/bin/ls" \
    --prefix PATH : "${
      lib.makeBinPath [
        pkgs.coreutils
        pkgs.gnugrep
        pkgs.util-linux
        pkgs.which
      ]
    }"
  '';

  mkItem =
    {
      name,
      app,
      icon,
      comment,
      categories,
      mimeTypes ? [ ],
    }:
    pkgs.makeDesktopItem {
      name = "freeoffice-${app}";
      desktopName = name;
      exec = "freeoffice-${app} %U";
      icon = "freeoffice-${icon}";
      inherit comment categories mimeTypes;
      startupNotify = true;
    };
in
pkgs.stdenv.mkDerivation {
  pname = "freeoffice";
  version = "${edition}.${version}";

  src = pkgs.fetchurl {
    url = "https://www.softmaker.net/down/softmaker-freeoffice-${edition}-${version}-amd64.tgz";
    inherit hash;
  };

  nativeBuildInputs = [
    pkgs.autoPatchelfHook
    pkgs.copyDesktopItems
    pkgs.makeWrapper
  ];

  # Shared libraries the binaries link against.
  buildInputs = [
    pkgs.curl
    pkgs.glib
    pkgs.gst_all_1.gstreamer
    pkgs.gst_all_1.gst-plugins-base
    pkgs.libGL
    pkgs.libX11
    pkgs.libXext
    pkgs.libXmu
    pkgs.libXrandr
    pkgs.libXrender
    (lib.getLib pkgs.stdenv.cc.cc)
  ];

  dontBuild = true;
  dontConfigure = true;

  # The tgz is an installer wrapper; unpack it, then unpack the inner lzma.
  unpackPhase = ''
    runHook preUnpack
    mkdir installer
    tar -C installer -xf $src
    mkdir freeoffice
    tar -C freeoffice -xf installer/${archive}
    runHook postUnpack
  '';

  installPhase = ''
    runHook preInstall

    mkdir -p $out/share
    cp -r freeoffice $out/share/freeoffice${edition}

    # Wrap (don't symlink) so each program can find its resource directory.
    mkdir -p $out/bin
    for app in planmaker presentations textmaker; do
      makeWrapper $out/share/freeoffice${edition}/$app $out/bin/freeoffice-$app \
        ${extraWrapperArgs}
    done

    # Application + mimetype icons across all shipped sizes.
    for size in 16 32 48 64 96 128 256 512 1024; do
      mkdir -p $out/share/icons/hicolor/''${size}x''${size}/apps
      for app in pml prl tml; do
        ln -s $out/share/freeoffice${edition}/icons/''${app}_''${size}.png \
          $out/share/icons/hicolor/''${size}x''${size}/apps/freeoffice-''${app}.png
      done
      mkdir -p $out/share/icons/hicolor/''${size}x''${size}/mimetypes
      for mt in pmd prd tmd; do
        ln -s $out/share/freeoffice${edition}/icons/''${mt}_''${size}.png \
          $out/share/icons/hicolor/''${size}x''${size}/mimetypes/application-x-''${mt}.png
      done
    done

    # Some revisions omit a few icon sizes -> drop the resulting dangling links.
    find $out -xtype l -exec rm {} \;

    # MIME type definitions.
    install -D -t $out/share/mime/packages \
      freeoffice/mime/softmaker-*office*${shortEdition}.xml

    runHook postInstall
  '';

  desktopItems = [
    (mkItem {
      name = "TextMaker (FreeOffice)";
      app = "textmaker";
      icon = "tml";
      comment = "Word processor compatible with Microsoft Word";
      categories = [
        "Office"
        "WordProcessor"
      ];
      mimeTypes = [
        "application/vnd.openxmlformats-officedocument.wordprocessingml.document"
        "application/msword"
        "application/vnd.oasis.opendocument.text"
      ];
    })
    (mkItem {
      name = "PlanMaker (FreeOffice)";
      app = "planmaker";
      icon = "pml";
      comment = "Spreadsheet application compatible with Microsoft Excel";
      categories = [
        "Office"
        "Spreadsheet"
      ];
      mimeTypes = [
        "application/vnd.openxmlformats-officedocument.spreadsheetml.sheet"
        "application/vnd.ms-excel"
        "application/vnd.oasis.opendocument.spreadsheet"
      ];
    })
    (mkItem {
      name = "Presentations (FreeOffice)";
      app = "presentations";
      icon = "prl";
      comment = "Presentation program compatible with Microsoft PowerPoint";
      categories = [
        "Office"
        "Presentation"
      ];
      mimeTypes = [
        "application/vnd.openxmlformats-officedocument.presentationml.presentation"
        "application/vnd.ms-powerpoint"
        "application/vnd.oasis.opendocument.presentation"
      ];
    })
  ];

  meta = {
    description = "Free office suite: TextMaker, PlanMaker and Presentations";
    homepage = "https://www.freeoffice.com/";
    sourceProvenance = with lib.sourceTypes; [ binaryNativeCode ];
    license = lib.licenses.unfree;
    platforms = [ "x86_64-linux" ];
  };
}
