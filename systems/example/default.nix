{
  inputs,
  ...
}:
{
  flake.systems.example = {
    type = "vm";
    hostname = "example-vm";
    arch = "x86_64-linux";
    os = "nixos";
    owner = "example";
    users = [ "example" ];
    graphical = false;
    packages.system = [
      "base.nix"
      #"system.nix"
      #"terminal.nix"
      #"services.nix"
    ];
    packages.home = [
      "base.nix"
      #"desktop.nix"
      #"development.nix"
      #"terminal.nix"
      #"sysadmin.nix"
    ];
    modules.nixos = [
      ./nixos.nix
      inputs.home-manager.nixosModules.home-manager
      #inputs.sops-nix.nixosModules.sops
      inputs.lix-module.nixosModules.default
      #inputs.stylix.nixosModules.stylix
      "base.nix"
      "example"
      #"dolphin.nix"
      "superuser.nix"
      "system-packages.nix"
      #"laptop.nix"
      "hm.nix"
      #"fonts.nix"
      "locale.nix"
      #"nix.nix"
      #"security.nix"
      #"networking.nix"
      #"shell.nix"
      #"xserver.nix"
      #"graphical.nix"
      #"hyprland.nix"
      #"video.nix"
      #"vpn.nix"
      #"unfree.nix"
      #"borgbase.nix"
      #"sway.nix"
      #"oom.nix"
      "users.nix"
      "fish.nix"
    ];
    modules.home = [
    ];
  };
}
