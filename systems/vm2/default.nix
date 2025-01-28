{ self, inputs, ... }:
{
  flake.systems.vm2 = {
    type = "vm";
    arch = "x86_64-linux";
    roles = {
      home = [ ];
      system = [ ];
    };
    modules =
      let
        root = ../../modules;
      in
      [
        ./nixos.nix
        (root + "/nixos/base.nix")
        (root + "/nixos/nix.nix")
        (root + "/nixos/unfree.nix")
        (root + "/nixos/virtual.nix")
      ];
    args = {
      flake = self;
    };
  };
}
