{
  description = "Nixos config flake";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";

    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs = { self, nixpkgs, ... }@inputs: {
    nixosConfigurations = {
      halley = nixpkgs.lib.nixosSystem {
        specialArgs = {inherit inputs;};
        modules = [
          ./hosts/halley/hardware-configuration.nix
          ./hosts/halley/configuration.nix
          inputs.home-manager.nixosModules.default
        ];
      };
      #peter = nixpkgs.lib.nixosSystem {
      #  specialArgs = {inherit inputs;};
      #  modules = [
      #    ./hosts/peter/hardware-configuration.nix
      #    ./hosts/peter/configuration.nix
      #    inputs.home-manager.nixosModules.default
      #  ]
      #}
    };
  };
}
