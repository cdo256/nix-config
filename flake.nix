{
  description = "Nixos config flake";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";
    flake-utils.url = "github:numtide/flake-utils"; # Utility functions for flakes
    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    #nixvim = {
    #  url = "github:nix-community/nixvim";
    #  inputs.nixpkgs.follows = "nixpkgs";
    #};
    nixvim = {
      url = "github:cdo256/nixvim-config";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    sops-nix = {
      url = "github:Mic92/sops-nix";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs = { self, nixpkgs, flake-utils, home-manager, nixvim, ... }@inputs: 
    let
      system = "x86_64-linux";
      pkgs = import nixpkgs { inherit system; };
      bootstrap = false;
      files = if bootstrap then
        pkgs.stdenv.mkDerivation {
          name = "files";
          src = ./.;
          buildPhase = "true"; # Do nothing.
          installPhase = ''
            mkdir -p $out
            cp -r $src/* $out/
          '';
        } else pkgs.fetchFromGitHub {
          owner = "cdo256";
          repo = "cdo-config";
          rev = "4ce2a70cbb2b5e47a0187a8367f321f63008a966";
          sha256 = "sha256-PoKR5QFWtVki6W5qfv/rCXslkpc3qvDA7TkFYw3ORKI=";
          private = true;
        };
    in
    {
      packages.x86_64-linux = {
        home-manager = home-manager.defaultPackage.x86_64-linux;
        files = files;
        nixvim = nixvim.packages.x86_64-linux.default;
      };
      devShells.x86_64-linux.default = pkgs.mkShell {
        nativeBuildInputs = [
          pkgs.gnumake
          pkgs.sops
          pkgs.just
          pkgs.nh
        ];
      };
      nixosConfigurations = {
        vm1 = nixpkgs.lib.nixosSystem {
          specialArgs = {
            inherit inputs;
            inherit files;
            inherit bootstrap;
            devices = import hosts/devices.nix;
          };
          modules = [
            ./hosts/vm1/configuration.nix
            inputs.home-manager.nixosModules.default
            inputs.sops-nix.nixosModules.sops
          ];
        };
        halley = nixpkgs.lib.nixosSystem {
          specialArgs = {
            inherit inputs;
            inherit files;
            inherit bootstrap;
            devices = import hosts/devices.nix;
          };
          modules = [
            ./hosts/halley/hardware-configuration.nix
            ./hosts/halley/configuration.nix
            inputs.home-manager.nixosModules.default
            inputs.sops-nix.nixosModules.sops
          ];
        };
        peter = nixpkgs.lib.nixosSystem {
          specialArgs = {
            inherit inputs;
            inherit files;
            inherit bootstrap;
            devices = import hosts/devices.nix;
          };
          modules = [
            ./hosts/peter/hardware-configuration.nix
            ./hosts/peter/configuration.nix
            inputs.home-manager.nixosModules.default
            inputs.sops-nix.nixosModules.sops
          ];
        };
      };
      homeConfigurations = {
        "cdo" = home-manager.lib.homeManagerConfiguration {
          extraSpecialArgs = {
            inherit inputs;
            inherit files;
          };
          pkgs = import nixpkgs { system = "x86_64-linux"; };
          modules = [
            ./home/client.nix 
          ];
        };
      };
    };
}
