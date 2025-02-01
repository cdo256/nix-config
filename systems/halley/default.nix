{ self, inputs, ... }:
{
  flake.systems.halley = {
    type = "laptop";
    hostname = "halley";
    arch = "x86_64-linux";
    owner = "cdo";
    roles = {
      home = [ ];
      system = [ ];
    };
    modules =
      let
        root = ../../modules;
      in
      [
        ./nixos.nix
        ./hardware.nix
        ./boot.nix
        inputs.home-manager.nixosModules.home-manager
        (root + "/nixos/base.nix")
        (root + "/nixos/cdo.nix")
        (root + "/nixos/superuser.nix")
        (root + "/nixos/system-packages.nix")
        (root + "/nixos/laptop.nix")
        (root + "/nixos/hm.nix")
        (root + "/nixos/fonts.nix")
        (root + "/nixos/locale.nix")
        (root + "/nixos/nix.nix")
        (root + "/nixos/security.nix")
        (root + "/nixos/networking.nix")
        (root + "/nixos/shell.nix")
        (root + "/nixos/xserver.nix")
        (root + "/nixos/graphical.nix")
        (root + "/nixos/hyprland.nix")
        (root + "/nixos/video.nix")
        (root + "/nixos/vpn.nix")
        (root + "/nixos/unfree.nix")
      ];
    args = {
      flake = self;
      moduleRoot = ../../modules;
    };
  };
}
