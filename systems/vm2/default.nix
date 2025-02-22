{
  self,
  inputs,
  config,
  ...
}:
{
  flake.systems.vm2 = {
    type = "vm";
    hostname = "vm2";
    arch = "x86_64-linux";
    graphical = false;
    owner = "cdo";
    roles = {
      home = [ ];
      system = [ ];
    };
    package.system = [ ];
    packages.home = [ ];
    modules.nixos =
      let
        root = ../../modules;
      in
      [
        ./nixos.nix
        inputs.home-manager.nixosModules.home-manager
        (root + "/nixos/base.nix")
        (root + "/nixos/cdo.nix")
        (root + "/nixos/superuser.nix")
        (root + "/nixos/system-packages.nix")
        (root + "/nixos/hm.nix")
        (root + "/nixos/fonts.nix")
        (root + "/nixos/locale.nix")
        (root + "/nixos/nix.nix")
        (root + "/nixos/security.nix")
        (root + "/nixos/shell.nix")
        (root + "/nixos/unfree.nix")
        (root + "/nixos/virtual.nix")
        (root + "/nixos/vm-networking.nix")
      ];
    modules.home = [ ];
    args = {
      flake = self;
      inherit (config.flake) repoRoot;
    };
  };
}
