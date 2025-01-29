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
        (root + "/nixos/cdo.nix")
        (root + "/nixos/locale.nix")
        (root + "/nixos/nix.nix")
        (root + "/nixos/security.nix")
        (root + "/nixos/shell.nix")
        (root + "/nixos/unfree.nix")
        (root + "/nixos/virtual.nix")
        (root + "/nixos/vm-networking.nix")
      ];
    args = {
      flake = self;
    };
  };
}
