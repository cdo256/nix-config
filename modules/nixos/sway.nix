# Derived from https://github.com/jvanbruegge/nix-config/tree/master/sway
{ pkgs, ... }:
{
  programs.sway = {
    enable = true;
  };
  xdg.portal = {
    enable = true;
    extraPortals = [ pkgs.xdg-desktop-portal-gtk ];
  };
  xdg.portal.configPackages = [ pkgs.gnome-session ];
  environment.sessionVariables = {
    NIXOS_OZONE_WL = "1";
  };
  hardware.opengl = {
    enable = true;
    driSupport32Bit = true;
  };

  security.pam.services.swaylock = { };
}
