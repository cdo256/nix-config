{
  self,
  inputs,
  config,
  ...
}:
{
  flake.systems.halley = {
    type = "laptop";
    hostname = "halley";
    arch = "x86_64-linux";
    owner = "cdo";
    packages.system = [
      "base.nix"
      "system.nix"
      "terminal.nix"
      "services.nix"
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
      ./hardware.nix
      ./boot.nix
      inputs.home-manager.nixosModules.home-manager
      inputs.sops-nix.nixosModules.sops
      "base.nix"
      "cdo"
      "dolphin.nix"
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
      "sway.nix"
      "oom.nix"
    ];
    modules.home = [
      ./home/hyprland.nix
      ./home/waybar.nix
    ];
    args = {
      flake = self;
    };
  };
}
