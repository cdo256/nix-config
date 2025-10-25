{
  self,
  inputs,
  config,
  ...
}:
{
  flake.systems.peter = {
    type = "desktop";
    hostname = "peter";
    arch = "x86_64-linux";
    os = "nixos";
    owner = "cdo";
    users = [ "cdo" ];
    graphical = true;
    packages.system = [
      "base.nix"
      "system.nix"
      "terminal.nix"
    ];
    packages.home = [
      "base.nix"
      "desktop.nix"
      "development.nix"
      "games.nix"
      "terminal.nix"
      "sysadmin.nix"
      "video.nix"
    ];
    modules.nixos = [
      ./nixos.nix
      ./boot.nix
      ./hardware.nix
      inputs.home-manager.nixosModules.home-manager
      inputs.sops-nix.nixosModules.sops
      inputs.lix-module.nixosModules.default
      "base.nix"
      "cdo"
      "superuser.nix"
      "system-packages.nix"
      "laptop.nix"
      "hm.nix"
      "fonts.nix"
      "locale.nix"
      "nix.nix"
      "security.nix"
      "networking.nix"
      "shell.nix"
      "xserver.nix"
      "graphical.nix"
      "hyprland.nix"
      "video.nix"
      "vpn.nix"
      "unfree.nix"
      "borgbase.nix"
      "steam.nix"
      "dolphin.nix"
      "sway.nix"
      "oom.nix"
      "netbird-client.nix"
      "users.nix"
      "fish.nix"
    ];
    modules.home = [ ];
  };
}
