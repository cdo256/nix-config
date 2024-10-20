{pkgs, ...}:

{
  imports =
    [
      ./hardware-configuration.nix
      ../default/configuration.nix
    ];
}