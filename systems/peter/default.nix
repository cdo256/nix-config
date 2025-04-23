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
    graphical = true;
    owner = "cdo";
    packages.system = [
      "base.nix"
      "system.nix"
      "terminal.nix"
    ];
    packages.home = [
      "base.nix"
      "desktop.nix"
      "development.nix"
      "terminal.nix"
      "sysadmin.nix"
    ];
    modules.nixos = [
      ./nixos.nix
      ./boot.nix
      ./hardware.nix
      inputs.home-manager.nixosModules.home-manager
      inputs.sops-nix.nixosModules.sops
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
      "devices.nix"
      "borgbase.nix"
      "sops.nix"
      "steam.nix"
      "dolphin.nix"
      "sway.nix"
    ];
    modules.home = [ ];
    args = {
      flake = self;
    };
  };
}
