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
        borgbase-api-client = pkgs.python3Packages.buildPythonPackage rec {
          pname = "borgbase-api-client";
          version = "1.0";
          src = pkgs.fetchFromGitHub {
            owner = "borgbase";
            repo = "borgbase-api-client";
            rev = "cbd4367817a4cb590612133a34eb8f8b2fa8b833";
            sha256 = "sha256-pcQLeJ6vYsHDeXxVbZEYoV14E2m0bN+tSLkDJ1Ehejg=";
          };
          propagatedBuildInputs = with pkgs.python3Packages; [
            requests
          ];
          meta = with pkgs.lib; {
            description = "Borgbase API client in python";
            license = licenses.mit;
          };
        };
        sopsy = pkgs.python3Packages.buildPythonPackage rec {
          pname = "sopsy";
          version = "1.1.0";
          src = pkgs.fetchFromGitHub {
            owner = "nikaro";
            repo = "sopsy";
            rev = "1.1.0";
            sha256 = "sha256-Z3LGfIvLuGTA+2uw4vOmXWN43QQ4pC0mw5fiEJKherk=";
          };
          format = "pyproject";
          propagatedBuildInputs = with pkgs.python3Packages; [
            pyyaml
            setuptools
            hatchling
          ];
          meta = with pkgs.lib; {
            description = "SOPS Python wrapper library";
            license = licenses.mit;
          };
        };
    in
    {
      packages.x86_64-linux.home-manager = home-manager.defaultPackage.x86_64-linux;
      packages.x86_64-linux.files = files;
      # For automatic setup in future.
      packages.x86_64-linux.borgbase-api-client = borgbase-api-client;
      packages.x86_64-linux.sopsy = sopsy;
      devShells.x86_64-linux.default = pkgs.mkShell {
        nativeBuildInputs = [
          pkgs.gnumake
          pkgs.sops
          pkgs.just
          pkgs.nh
          sopsy
          borgbase-api-client
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
