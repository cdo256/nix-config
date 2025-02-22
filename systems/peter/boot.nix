{ config, lib, ... }:
let
  inherit (lib) mkIf;
in
{
  config.boot = {
    loader = {
      efi.canTouchEfiVariables = true;
      grub = {
        enable = true;
        device = "/dev/disk/by-uuid/3DD8-219F";
        useOSProber = true;
      };
    };
  };
}
