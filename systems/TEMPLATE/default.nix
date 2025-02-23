{
  self,
  inputs,
  config,
  ...
}:
{
  flake.systems.halley = {
    type = "TODO"; # "laptop", "desktop", "phone", "tablet", "server"
    os = "TODO"; # "nixos", "debian", "android"
    hostname = "TODO";
    syncthingId = "XXXXXXX-XXXXXXX-XXXXXXX-XXXXXXX-XXXXXXX-XXXXXXX-XXXXXXX-XXXXXXX";
    sshPublicKey = "ssh-ed25519 XXXXXXXXXXXXXXXXXXXXXXXXXXXX cdo@HOSTNAME";
    #arch = "x86_64-linux";
    owner = "cdo";
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
        root = config.flake.repoRoot + "/modules/nixos";
      in
      [
        ./nixos.nix
        ./hardware.nix
        ./boot.nix
        inputs.home-manager.nixosModules.home-manager
        inputs.sops-nix.nixosModules.sops
        (root + "/base.nix")
        (root + "/cdo.nix")
        (root + "/superuser.nix")
        (root + "/system-packages.nix")
        (root + "/laptop.nix")
        (root + "/hm.nix")
        (root + "/fonts.nix")
        (root + "/locale.nix")
        (root + "/nix.nix")
        (root + "/security.nix")
        (root + "/networking.nix")
        (root + "/shell.nix")
        (root + "/xserver.nix")
        (root + "/graphical.nix")
        (root + "/hyprland.nix")
        (root + "/video.nix")
        (root + "/vpn.nix")
        (root + "/unfree.nix")
        (root + "/devices.nix")
        (root + "/syncnet.nix")
        (root + "/borgbase.nix")
        (root + "/sops.nix")
      ];
    args = {
      flake = self;
      inherit (config.flake) repoRoot;
    };
  };
}
