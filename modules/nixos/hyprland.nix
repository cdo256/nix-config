{
  pkgs,
  inputs,
  config,
  ...
}:

let
  system = config.args.arch;
  hyprland-pkgs = inputs.hyprland.inputs.nixpkgs.legacyPackages.${system};
in
{
  programs.hyprland = {
    enable = true;
    package = inputs.hyprland.packages.${system}.hyprland;
    portalPackage = inputs.hyprland.packages.${system}.xdg-desktop-portal-hyprland;
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
    package = hyprland-pkgs.mesa;
    driSupport32Bit = true;
    package32 = hyprland-pkgs.pkgsi686Linux.mesa;
  };
  # Optional
  security.pam.services.hyprlock = { };
}
