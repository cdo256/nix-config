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
  arch = "x86_64-linux";
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
    args = {
      inherit arch;
      type = "vm";
      owner = "cdo";
    };
    services.printing.enable = true;
    services = {
      #borgbase.enable = false;
      #syncnet.enable = true;
      #syncnet.devices = config.devices;
    };
  };
}
