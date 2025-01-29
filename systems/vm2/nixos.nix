{
  self,
  nix,
  config,
  lib,
  pkgs,
  nixpkgs,
  stdenv,
  inputs,
  #files,
  flake,
  ...
}:
let
  packages = flake.lib.mkPackageList {
    modules = [
      "/base.nix"
      "/system.nix"
    ];
    inherit (config.nixpkgs.hostPlatform) system;
  };
in
{
  imports = [
    #../devices.nix
    #../../os-modules/syncnet.nix
    #../../os-modules/borgbase.nix
    #../../os-modules/sops.nix
    #inputs.home-manager.nixosModules.default
  ];

  config = {
    environment = {
      systemPackages = packages;
    };
    services.printing.enable = true;
    services = {
      #borgbase.enable = false;
      #syncnet.enable = true;
      #syncnet.devices = config.devices;
    };
  };
}
