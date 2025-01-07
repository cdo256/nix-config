{
  pkgs,
  inputs,
  system,
  ...
}:

{
  programs.hyprland = {
    enable = true;
    package = inputs.hyprland.packages.${system}.hyprland;
    portalPackage = inputs.hyprland.packages.${system}.xdg-desktop-portal-hyprland;
  };
  environment.systemPackages = [
    pkgs.kitty # Default terminal
  ];
}
