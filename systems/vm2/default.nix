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
        modules = ../../modules;
      in
      [
        ./nixos.nix
        (modules + "/nixos/base.nix")
        (modules + "/nixos/nix.nix")
        (modules + "/nixos/unfree.nix")
        (modules + "/nixos/virtual.nix")
      ];
  };
}
