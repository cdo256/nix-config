{
  description = "Nixos config flake";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";
    flake-utils.url = "github:numtide/flake-utils"; # Utility functions for flakes
    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    nixvim = {
      url = "github:nix-community/nixvim";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs = { self, nixpkgs, flake-utils, home-manager, nixvim, ... }@inputs: 
    let
      system = "x86_64-linux";
      pkgs = import nixpkgs { inherit system; };
      bootstrap = true;
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
          rev = "master";
          sha256 = "sha256-yjqRcNp0JF6vYr6hQSIe4csATrOI3kCBInGekRySCPg=";
          private = true;
        };
    in
    {
      packages.x86_64-linux.home-manager = home-manager.defaultPackage.x86_64-linux;
      packages.x86_64-linux.files = files;
      devShells.x86_64-linux.default = pkgs.mkShell {
        nativeBuildInputs = [ pkgs.gnumake ];
      };
      nixosConfigurations = {
        vm1 = nixpkgs.lib.nixosSystem {
          specialArgs = {
            inherit inputs;
            inherit files;
            devices = import hosts/devices.nix;
          };
          modules = [
            ./hosts/vm1/configuration.nix
            inputs.home-manager.nixosModules.default
          ];
        };
        halley = nixpkgs.lib.nixosSystem {
          specialArgs = {
            inherit inputs;
            inherit files;
            devices = import hosts/devices.nix;
          };
          modules = [
            ./hosts/halley/hardware-configuration.nix
            ./hosts/halley/configuration.nix
            inputs.home-manager.nixosModules.default
          ];
        };
        peter = nixpkgs.lib.nixosSystem {
          specialArgs = {
            inherit inputs;
            inherit files;
            devices = import hosts/devices.nix;
          };
          modules = [
            ./hosts/peter/hardware-configuration.nix
            ./hosts/peter/configuration.nix
            inputs.home-manager.nixosModules.default
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
