{
  services = {
    displayManager.gdm.enable = true;
    displayManager.gdm.wayland = true;
    desktopManager.gnome.enable = true;

    xserver = {
      enable = true;
      xkb = {
        layout = "gb";
        variant = "";
        options = "caps:escape";
      };
    };
  };
}
