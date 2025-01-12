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
  environment.systemPackages = [
    pkgs.waybar
    pkgs.kitty # Default terminal
    pkgs.dunst # Notification daemon
    pkgs.libnotify
    pkgs.wofi # Launcher
    pkgs.swww # Wallpaper daemon
    pkgs.hyprshot
    pkgs.hyprpicker
    pkgs.swappy
    pkgs.imv
    pkgs.wf-recorder
    pkgs.wl-clipboard
    pkgs.brightnessctl
    pkgs.gnome-themes-extra
    pkgs.libva
    pkgs.dconf
    pkgs.qt6.qtwayland
    pkgs.wayland-utils
    pkgs.wayland-protocols
    pkgs.glib
    pkgs.bluez
    pkgs.wireplumber
    pkgs.libgtop
    pkgs.networkmanager
    pkgs.dart-sass
    pkgs.upower
    pkgs.gvfs

  ];
  hardware.opengl = {
    enable = true;
    package = hyprland-pkgs.mesa.drivers;
    driSupport32Bit = true;
    package32 = hyprland-pkgs.pkgsi686Linux.mesa.drivers;
  };
  services.upower.enable = true;
  # Optional
  security.pam.services.hyprlock = { };
}
