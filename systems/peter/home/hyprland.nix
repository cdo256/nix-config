{
  wayland.windowManager.hyprland.settings = {
    monitor = [
      "HDMI-A-2, 1920x1200, 0x0, 0.5" # Try scaling
      "DP-4, 3840x2160, 3840x0, 1"
      #"DP-6, 1920x1080, 7680x0, 1" # TV
      "DP-6, disabled" # TV

      # Automatically place each new monitor on the right of the others.
      ", preferred, auto, 1"
    ];
  };
}
