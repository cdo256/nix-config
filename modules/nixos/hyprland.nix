{
  pkgs,
  inputs,
  config,
  ...
}:
{
  programs.hyprland = {
    enable = true;
    package = pkgs.hyprland;
    portalPackage = pkgs.xdg-desktop-portal-hyprland;
    xwayland.enable = true;
    withUWSM = true;
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
  # Optional
  security.pam.services.hyprlock = { };
}
