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
    roles = {
      system = [ ];
      home = [ ];
    };
    packages =
      let
        root = config.flake.repoRoot + "/manifests";
      in
      {
        system = [
          (root + "/base.nix")
          (root + "/system.nix")
          (root + "/terminal.nix")
        ];
        home = [
          (root + "/base.nix")
          (root + "/desktop.nix")
          (root + "/development.nix")
          (root + "/terminal.nix")
          (root + "/sysadmin.nix")
        ];
      };
    modules =
      let
        root = config.flake.repoRoot + "/modules";
      in
      [
        ./nixos.nix
        ./hardware.nix
        ./boot.nix
        inputs.home-manager.nixosModules.home-manager
        (root + "/nixos/base.nix")
        (root + "/nixos/cdo.nix")
        (root + "/nixos/dolphin.nix")
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
      inherit (config.flake) repoRoot;
    };
  };
}
