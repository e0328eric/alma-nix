{
  lib,
  stdenvNoCC,
  fetchFromGitHub,
  makeWrapper,
  cabextract,
  unzip,
  p7zip,
  curl,
  wget,
  gnused,
  gawk,
  coreutils,
  perl,
  bash,
}:

let
  # Latest tag as shown on GitHub releases.
  # Update when you want a newer one.
  version = "20260125"; # :contentReference[oaicite:2]{index=2}
in
stdenvNoCC.mkDerivation {
  pname = "winetricks";
  inherit version;

  src = fetchFromGitHub {
    owner = "Winetricks";
    repo = "winetricks";
    rev = version;
    hash = "sha256-uIBVESebsH7rXnxWd/qlrZxcG7Y486PctHzcLz29HDk="; # lib.fakeHash;
  };

  nativeBuildInputs = [ makeWrapper ];

  dontBuild = true;

  installPhase = ''
    runHook preInstall

    install -Dm755 src/winetricks $out/bin/winetricks

    # Winetricks expects common helpers at runtime.
    wrapProgram $out/bin/winetricks \
      --prefix PATH : ${
        lib.makeBinPath [
          bash
          coreutils
          gnused
          gawk
          perl
          curl
          wget
          unzip
          p7zip
          cabextract
        ]
      }

    # Optional docs/manpages if present in the tarball
    if [ -f "src/winetricks.1" ]; then
      install -Dm644 src/winetricks.1 $out/share/man/man1/winetricks.1
    fi

    runHook postInstall
  '';

  meta = with lib; {
    description = "Winetricks from GitHub release tarball";
    homepage = "https://github.com/Winetricks/winetricks";
    license = licenses.lgpl21Plus;
    platforms = platforms.linux;
  };
}
