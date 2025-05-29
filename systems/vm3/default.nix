{
  self,
  inputs,
  config,
  ...
}:
{
  flake.systems.vm3 = {
    type = "vm";
    hostname = "vm3";
    arch = "x86_64-linux";
    os = "nixos";
    owner = "cdo";
    graphical = true;
    packages.system = [
      "base.nix"
      "system.nix"
    ];
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
      "borgbase.nix"
    ];
    modules.home = [ ];
  };
}
