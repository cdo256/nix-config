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
    os = "nixos";
    owner = "cdo";
    graphical = false;
    packages.system = [ ];
    packages.home = [ ];
    modules.nixos = [
      ./nixos.nix
      inputs.home-manager.nixosModules.home-manager
      inputs.sops-nix.nixosModules.sops
      inputs.lix-module.nixosModules.default
      "base.nix"
      "cdo"
      "superuser.nix"
      "system-packages.nix"
      "hm.nix"
      "fonts.nix"
      "locale.nix"
      "nix.nix"
      "security.nix"
      "shell.nix"
      "unfree.nix"
      "virtual.nix"
      "vm-networking.nix"
      "devices.nix"
      "borgbase.nix"
      "sops.nix"
    ];
    modules.home = [ ];
  };
}
