{
  self,
  nixpkgs,
  flake-utils,
  home-manager,
  nixvim,
  hyprland,
  hyprpanel,
  ...
}@inputs:
let
  system = "x86_64-linux";
  pkgs = import nixpkgs { inherit system; };
  files = pkgs.stdenv.mkDerivation {
    name = "files";
    src = ../.;
    buildPhase = "true"; # Do nothing.
    installPhase = ''
      mkdir -p $out
      cp -r $src/files/* $out/
    '';
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
        inherit system;
        devices = import hosts/devices.nix;
      };
      modules = [
        ../hosts/vm1/configuration.nix
        inputs.home-manager.nixosModules.default
        inputs.sops-nix.nixosModules.sops
      ];
    };
    halley = nixpkgs.lib.nixosSystem {
      specialArgs = {
        inherit inputs;
        inherit files;
        inherit system;
        devices = import hosts/devices.nix;
      };
      modules = [
        ../hosts/halley/hardware-configuration.nix
        ../hosts/halley/configuration.nix
        inputs.home-manager.nixosModules.default
        inputs.sops-nix.nixosModules.sops
      ];
    };
    peter = nixpkgs.lib.nixosSystem {
      specialArgs = {
        inherit inputs;
        inherit files;
        inherit system;
        devices = import hosts/devices.nix;
      };
      modules = [
        ../hosts/peter/hardware-configuration.nix
        ../hosts/peter/configuration.nix
        inputs.home-manager.nixosModules.default
        inputs.sops-nix.nixosModules.sops
      ];
    };
  };
  homeConfigurations = {
    "client" = home-manager.lib.homeManagerConfiguration {
      extraSpecialArgs = {
        inherit inputs;
        inherit files;
        inherit system;
        extraImports = [ ];
      };
      pkgs = import nixpkgs { system = "x86_64-linux"; };
      modules = [
        ../home/client.nix
      ];
    };
    "server" = home-manager.lib.homeManagerConfiguration {
      extraSpecialArgs = {
        inherit inputs;
        inherit files;
        inherit system;
        extraImports = [ ];
      };
      pkgs = import nixpkgs { system = "x86_64-linux"; };
      modules = [
        ../home/server.nix
      ];
    };
  };
}
