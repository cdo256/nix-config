{ config, pkgs, ... }:

let
  plasmaPackages = pkgs.plasma5Packages;
in
{
  services.desktopManager.plasma6 = {
    enable = true;
  };
}
