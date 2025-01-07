{
  pkgs,
  inputs,
  system,
  ...
}:

let
  hyprland-pkgs = inputs.hyprland.inputs.nixpkgs.legacyPackages.${system};
in
{
  programs.hyprland = {
    enable = true;
    package = inputs.hyprland.packages.${system}.hyprland;
    portalPackage = inputs.hyprland.packages.${system}.xdg-desktop-portal-hyprland;
  };
  environment.systemPackages = [
    pkgs.kitty # Default terminal
  ];
  hardware.opengl = {
    package = hyprland-pkgs.mesa.drivers;
    driSupport32Bit = true;
    package32 = hyprland-pkgs.pkgsi686Linux.mesa.drivers;
  };
}
