{
  self,
  inputs,
  config,
  ...
}:
{
  flake.systems.makeda = {
    type = "server";
    os = "nixos";
    hostname = "maked";
    #sshPublicKey = "ssh-ed25519 XXXXXXXXXXXXXXXXXXXXXXXXXXXX cdo@HOSTNAME";
    arch = "x86_64-linux";
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
          (root + "/development.nix")
          (root + "/terminal.nix")
          (root + "/sysadmin.nix")
        ];
      };
    modules.nixos =
      let
        root = config.flake.repoRoot + "/modules/nixos";
      in
      [
        ./nixos.nix
        ./hardware.nix
        ./boot.nix
	
	./sshd.nix
        inputs.home-manager.nixosModules.home-manager
        inputs.sops-nix.nixosModules.sops
        (root + "/base.nix")
        (root + "/cdo.nix")
        (root + "/superuser.nix")
        (root + "/system-packages.nix")
        (root + "/hm.nix")
        (root + "/locale.nix")
        (root + "/nix.nix")
        (root + "/security.nix")
        (root + "/networking.nix")
        (root + "/shell.nix")
        (root + "/unfree.nix")
        (root + "/devices.nix")
        (root + "/borgbase.nix")
        (root + "/sops.nix")
        (root + "/linode.nix")
      ];
    args = {
      flake = self;
      inherit (config.flake) repoRoot;
    };
  };
}
