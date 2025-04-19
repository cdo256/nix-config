{
  services.xserver = {
    enable = true;
    displayManager.gdm.enable = true;
    displayManager.gdm.wayland = true;
    desktopManager.gnome.enable = true;
    xkb = {
      layout = "gb";
      variant = "";
      options = "caps:escape";
    };
  };
}
