{ pkgs, ... }:
let
  sddmAlmaTheme = pkgs.stdenv.mkDerivation {
    name = "almagest-sddm";
    src = ./almagest-sddm;
    installPhase = ''
      mkdir -p $out/share/sddm/themes/almagest-sddm
      cp -r * $out/share/sddm/themes/almagest-sddm
    '';
  };
in
{
  environment.systemPackages = with pkgs; [
    alacritty
    bat
    binutils
    clang-tools
    cmake
    emacs-pgtk
    expressvpn
    fasm
    file
    fish
    foot
    gcc
    ghostty
    go
    gnumake
    git
    kitty
    kmod
    libfido2
    libinput
    lld
    llvmPackages_22.clang
    nbfc-linux
    neovim
    ninja
    nushell
    ripgrep
    (pkgs.rustup.overrideAttrs (oldAttrs: {
      doCheck = false;
    }))
    sdl3
    sdl3-image
    vcpkg
    vlang
    vim
    wget
    wineWow64Packages.stable
    winetricks-git
    yubikey-manager
    sddmAlmaTheme
    zlib
  ];

  # zoom
  programs.zoom-us.enable = true;
}
