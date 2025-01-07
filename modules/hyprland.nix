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
    xwayland.enable = true;
  };
  environment = {
    systemPackages = [
      pkgs.kitty # Default terminal
    ];
    sessionVariables = {
      NIXOS_OZONE_WL = "1";
    };
  };
  hardware.opengl = {
    enable = true;
    package = hyprland-pkgs.mesa.drivers;
    driSupport32Bit = true;
    package32 = hyprland-pkgs.pkgsi686Linux.mesa.drivers;
  };
}
