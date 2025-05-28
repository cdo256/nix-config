{
  self,
  inputs,
  config,
  ...
}:
{
  flake.systems.makeda = {
    type = "server";
    hostname = "makeda";
    arch = "x86_64-linux";
    os = "nixos";
    owner = "cdo";
    graphical = false;
    packages.system = [
      "base.nix"
      "system.nix"
      "terminal.nix"
    ];
    packages.home = [
      "base.nix"
      "development.nix"
      "terminal.nix"
      "sysadmin.nix"
    ];
    modules.nixos = [
      ./nixos.nix
      ./hardware.nix
      ./boot.nix
      ./sshd.nix
      inputs.home-manager.nixosModules.home-manager
      inputs.sops-nix.nixosModules.sops
      inputs.lix-module.nixosModules.default
      "base.nix"
      "cdo"
      "superuser.nix"
      "system-packages.nix"
      "hm.nix"
      "locale.nix"
      "nix.nix"
      "security.nix"
      "networking.nix"
      "shell.nix"
      "unfree.nix"
      "devices.nix"
      "borgbase.nix"
      "linode.nix"
      "netbird-server.nix"
    ];
  };
}
