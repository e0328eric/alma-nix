{
  lib,
  stdenv,
  fetchFromGitHub,
  meson,
  ninja,
  vala,
  pkg-config,
  gettext,
  desktop-file-utils,
  appstream-glib,
  wrapGAppsHook4,
  blueprint-compiler,
  glib,
  gtk4,
  libadwaita,
  libgee,
  json-glib,
  libarchive,
  libsoup_3,
  glib-networking,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "protonplus-git";
  version = "0.5.20";

  src = fetchFromGitHub {
    owner = "Vysp3r";
    repo = "ProtonPlus";
    rev = "v${finalAttrs.version}";
    hash = "sha256-XLA5dEG3gshvklk1te3VF1lqJmeeclNCWn2R/35pq/E=";
  };

  nativeBuildInputs = [
    meson
    ninja
    vala
    pkg-config
    gettext
    desktop-file-utils
    appstream-glib
    wrapGAppsHook4
    blueprint-compiler
    glib
  ];

  buildInputs = [
    glib
    gtk4
    libadwaita
    libgee
    json-glib
    libarchive
    libsoup_3
    glib-networking
  ];

  preFixup = ''
    gappsWrapperArgs+=(
      --prefix GIO_EXTRA_MODULES : "${glib-networking}/lib/gio/modules"
    )
  '';

  meta = {
    description = "Modern manager for GE-Proton, Wine-GE, and more";
    homepage = "https://github.com/Vysp3r/ProtonPlus";
    license = lib.licenses.gpl3Plus;
    platforms = lib.platforms.linux;
    mainProgram = "com.vysp3r.ProtonPlus";
  };
})
