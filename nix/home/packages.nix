# packages installed only on almagest user using home-manager

{ pkgs, lib, ... }:
let
  synologyDriveClient = pkgs.callPackage ./synology-drive.nix { };
  codexDesktop = pkgs.callPackage ./codex.nix { };
  freeoffice = pkgs.callPackage ./freeoffice.nix { };
  comfyui = pkgs.callPackage ./comfyui.nix { };
  vesti-fhs = import ./vesti-fhs.nix { inherit pkgs; };
in
{
  home.packages = with pkgs; [
    #aegisub
    brave
    brightnessctl
    (btop.override { cudaSupport = true; })
    cloc
    claude-code
    codex
    codexDesktop
    dunst
    eza
    fastfetch
    ffmpeg
    freeoffice
    fzf
    gdb
    herdr
    iconv
    imagemagick
    kdePackages.kdeconnect-kde
    lazygit
    lenovo-legion
    man-pages
    mimeo
    nerd-fonts.departure-mono
    nerd-fonts.d2coding
    nerd-fonts.jetbrains-mono
    nixfmt
    nix-search-tv
    nixpkgs-fmt
    nodejs
    obs-studio
    oh-my-posh
    pamixer
    pavucontrol
    qutebrowser
    sane-airscan # driverless scan
    simple-scan
    signal-desktop
    slurp
    starship
    streamlink
    swayimg
    synologyDriveClient
    texliveFull
    thunderbird-latest
    tree-sitter
    typst
    unzip
    upx
    vlc
    wlroots
    yt-dlp
    zathura
    zathuraPkgs.zathura_djvu
    zathuraPkgs.zathura_pdf_mupdf
    zenity
    zip
    (pkgs.writeShellScriptBin "ns" (builtins.readFile "${pkgs.nix-search-tv.src}/nixpkgs.sh"))
    vesti-fhs
    python313Packages.black
  ];
}
