# Nix shell for building the RAD Debugger as a self-contained binary that runs
# on other Linux distributions, and for packaging it as a standalone AppImage.
#
#   nix-shell
#   bash build.sh raddbg release   # build/raddbg, runnable in place on NixOS
#   make-appimage                  # build/raddbg-x86_64.AppImage, for any distro
#
# FreeType is linked statically. glibc, the X11 client libraries and EGL/GL
# stay dynamic and are taken from the host: the GPU driver is loaded at runtime
# and drives our X11 connection through the host's libX11/libxcb, so linking a
# second, static copy of those into the binary would corrupt shared connection
# state (e.g. libxcb's extension cache).
#
# Compiling with `zig cc` links against stubs of an old glibc instead of Nix's
# current one, so the binaries only require `glibcVersion` from the host.
{
  pkgs ? import <nixpkgs> { },
  # gettid() and sem_clockwait() need 2.30.
  glibcVersion ? "2.30",
}:

let
  inherit (pkgs) lib;

  # Static archive only, without the optional zlib/bzip2/PNG/brotli/HarfBuzz
  # backends, so `-lfreetype` pulls in nothing else. The debugger only
  # rasterizes TrueType/OpenType outlines. C17, no _GNU_SOURCE and no fortify
  # keep its libc references (e.g. no C23 __isoc23_strtol) linkable against an
  # old glibc.
  freetype =
    (pkgs.freetype.override { stdenv = pkgs.makeStaticLibraries pkgs.stdenv; }).overrideAttrs
      (old: {
        # Only needed to dlopen() HarfBuzz, which is disabled below.
        postPatch = (old.postPatch or "") + ''
          substituteInPlace src/autofit/ft-hb.c --replace-fail "#  define _GNU_SOURCE  1" ""
        '';
        propagatedBuildInputs = [ ];
        configureFlags = old.configureFlags ++ [
          "--with-zlib=no"
          "--with-bzip2=no"
          "--with-png=no"
          "--with-brotli=no"
          "--with-harfbuzz=no"
        ];
        env = old.env // {
          CFLAGS = "-std=gnu17";
        };
        hardeningDisable = [ "all" ];
      });

  hostLibs = [
    pkgs.libx11
    pkgs.libxext
    pkgs.libxfixes
    pkgs.libxrandr
    pkgs.libglvnd
  ];

  appimageRuntime = pkgs.fetchurl {
    url = "https://github.com/AppImage/type2-runtime/releases/download/20251108/runtime-x86_64";
    hash = "sha256-L8qLRDySUQ8Ug6iD9gBhrQm0a5eLJjHIB82HOkfsJg0=";
  };

  makeAppImage = pkgs.writeShellApplication {
    name = "make-appimage";
    runtimeInputs = [
      pkgs.patchelf
      pkgs.squashfsTools
    ];
    text = ''
      cd ${lib.escapeShellArg (toString ./.)}
      "$BASH" build.sh raddbg release

      appdir=build/raddbg.AppDir
      rm -rf "$appdir"
      mkdir -p "$appdir/usr/bin"
      install -m755 build/raddbg "$appdir/usr/bin/raddbg"
      # Load through the host's dynamic linker and libraries, not /nix/store.
      patchelf --set-interpreter /lib64/ld-linux-x86-64.so.2 --remove-rpath "$appdir/usr/bin/raddbg"
      ln -s usr/bin/raddbg "$appdir/AppRun"
      install -m644 data/logo.png "$appdir/raddbg.png"
      ln -s raddbg.png "$appdir/.DirIcon"
      cat > "$appdir/raddbg.desktop" <<'EOF'
      [Desktop Entry]
      Type=Application
      Name=RAD Debugger
      Exec=raddbg
      Icon=raddbg
      Categories=Development;Debugger;
      Terminal=false
      EOF

      mksquashfs "$appdir" build/raddbg.squashfs -comp zstd -all-root -noappend -quiet -no-progress
      cat ${appimageRuntime} build/raddbg.squashfs > build/raddbg-x86_64.AppImage
      chmod +x build/raddbg-x86_64.AppImage
      rm build/raddbg.squashfs
      echo "[built build/raddbg-x86_64.AppImage]"
    '';
  };
in
pkgs.mkShellNoCC {
  packages = [
    pkgs.zig
    pkgs.pkg-config
    pkgs.git
    makeAppImage
  ];

  buildInputs = [ freetype ] ++ hostLibs;

  # build.sh honors $CC and $AR. The Nix loader and rpath let build outputs
  # (including metagen, which build.sh runs) start in place on NixOS;
  # make-appimage swaps them for the host's.
  env = {
    CC = lib.concatStringsSep " " [
      "zig cc -target x86_64-linux-gnu.${glibcVersion}"
      # build.sh's own -mcx16 gets glued onto -DBUILD_GIT_HASH_FULL in git
      # checkouts; without it 128-bit atomics become lock-based libcalls.
      "-mcx16"
      # zig cc enables UBSan traps in unoptimized builds and makes __DATE__
      # (used in the build title) an error by default.
      "-fno-sanitize=all"
      "-Wno-date-time"
      # Xrandr.h includes Xrender.h, but xrandr.pc only lists xrender in
      # Requires.private, so `pkg-config --cflags xrandr` omits its headers.
      "-isystem ${lib.getDev pkgs.libxrender}/include"
      "-Wl,--dynamic-linker=${lib.getLib pkgs.glibc}/lib/ld-linux-x86-64.so.2"
      "-Wl,-rpath,${lib.makeLibraryPath hostLibs}"
    ];
    AR = "zig ar";
  };

  # Nix pins this to 1980 for reproducibility, which would stamp that date
  # into the __DATE__ shown in the debugger's title.
  shellHook = ''
    unset SOURCE_DATE_EPOCH
  '';
}
