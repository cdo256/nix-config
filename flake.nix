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
    in
    {
      devShells.x86_64-linux.default = pkgs.mkShell {
        nativeBuildInputs = [ pkgs.gnumake ];
      };
      nixosConfigurations = {
        halley = nixpkgs.lib.nixosSystem {
          specialArgs = {
            inherit inputs;
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
        "cdo@halley" = home-manager.lib.homeManagerConfiguration {
           modules = [
             ./home/client.nix 
           ];
         };
       };
     };
}
