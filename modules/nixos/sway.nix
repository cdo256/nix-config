# Derived from https://github.com/jvanbruegge/nix-config/tree/master/sway
{ pkgs, ... }:
{
  programs.sway = {
    enable = true;
  };
  xdg.portal = {
    enable = true;
    extraPortals = [ pkgs.xdg-desktop-portal-gtk ];
    configPackages = [ pkgs.gnome-session ];
  };
  environment.sessionVariables = {
    NIXOS_OZONE_WL = "1";
  };
  hardware.graphics = {
    enable = true;
    enable32Bit = true;
  };

  security.pam.services.swaylock = { };
}
