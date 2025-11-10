{
  inputs,
  ...
}:
{
  flake.systems.halley = {
    type = "laptop";
    hostname = "halley";
    arch = "x86_64-linux";
    os = "nixos";
    owner = "cdo";
    users = [ "cdo" ];
    graphical = true;
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
      "games.nix"
    ];
    modules.nixos = [
      ./nixos.nix
      ./hardware.nix
      ./boot.nix
      inputs.home-manager.nixosModules.home-manager
      inputs.sops-nix.nixosModules.sops
      inputs.lix-module.nixosModules.default
      inputs.stylix.nixosModules.stylix
      "base.nix"
      "cdo"
      #"dolphin.nix"
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
      "video.nix"
      "vpn.nix"
      "unfree.nix"
      "borgbase.nix"
      "sway.nix"
      "oom.nix"
      "users.nix"
      "fish.nix"
      "stylix.nix"
      "gnome.nix"
    ];
    modules.home = [
      ./home/hyprland.nix
      ./home/waybar.nix
      #inputs.stylix.homeModules.stylix
      #"stylix.nix"
    ];
  };
}
