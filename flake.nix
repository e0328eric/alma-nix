{
  description = "Almagest NixOS";

  inputs = {
    nixpkgs.url = "nixpkgs/nixos-unstable";
    nixos-hardware.url = "github:NixOS/nixos-hardware/master";
    stylix.url = "github:danth/stylix";
    vicinae.url = "github:vicinaehq/vicinae";
    honkai-railway-grub-theme.url = "github:voidlhf/StarRailGrubThemes";
    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    mangowm = {
      url = "github:mangowm/mango";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    noctalia = {
      url = "github:noctalia-dev/noctalia";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    aagl = {
      url = "github:ezKEa/aagl-gtk-on-nix";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs =
    {
      nixpkgs,
      nixos-hardware,
      vicinae,
      stylix,
      mangowm,
      aagl,
      home-manager,
      ...
    }@inputs:
    let
      isInstall = builtins.getEnv "ALMA_INSTALL" == "1";
      nixVars = import ./variables.nix;
      nixosHardwareModule = nixVars.nixosHardwareModule or "lenovo-legion-16irx9h";
      nixosHardwareModules =
        if nixosHardwareModule == null || nixosHardwareModule == "" then
          [ ]
        else if builtins.hasAttr nixosHardwareModule nixos-hardware.nixosModules then
          [ nixos-hardware.nixosModules.${nixosHardwareModule} ]
        else
          throw "Unknown nixos-hardware module '${nixosHardwareModule}'. Check variables.nix.";
    in
    {
      overlays.default = final: prev: {
        winetricks-git = final.callPackage ./pkgs/winetricks-git.nix { };
        protonplus-git = final.callPackage ./pkgs/protonplus.nix { };

        lutris-unwrapped-new = prev.lutris-unwrapped.overrideAttrs (old: rec {
          version = "0.5.22";
          src = prev.fetchFromGitHub {
            owner = "lutris";
            repo = "lutris";
            rev = "v${version}";
            hash = "sha256-4mNknvfJQJEPZjQoNdKLQcW4CI93D6BUDPj8LtD940A=";
          };
        });

        lutris-git = prev.lutris.override {
          lutris-unwrapped = final.lutris-unwrapped-new;
        };

        openldap = prev.openldap.overrideAttrs (oldAttrs: {
          doCheck = false; # Disables the flaky test suite
        });
      };

      nixosConfigurations.almanixos = nixpkgs.lib.nixosSystem {
        system = "x86_64-linux";
        specialArgs = { inherit inputs; };
        modules = [
          ./configuration.nix
          stylix.nixosModules.stylix
          aagl.nixosModules.default
          mangowm.nixosModules.mango
        ]
        ++ nixosHardwareModules
        ++ [
          (
            { ... }:
            {
              nixpkgs.overlays = [ inputs.self.overlays.default ];
              nixpkgs.config.allowUnfree = true;
            }
          )
        ]
        ++ nixpkgs.lib.optionals (!isInstall) [
          home-manager.nixosModules.home-manager
          {
            home-manager = {
              useGlobalPkgs = true;
              useUserPackages = true;
              extraSpecialArgs = { inherit inputs; };
              users.almagest =
                { ... }:
                {
                  imports = [
                    ./home.nix
                    vicinae.homeManagerModules.default
                  ];
                };
              backupFileExtension = "backup";
            };
          }
        ];
      };
    };
}
