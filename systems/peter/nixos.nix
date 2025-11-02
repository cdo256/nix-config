{
  config,
  ...
}:
{
  config = {
    home-manager.users.${config.args.owner}.wayland.windowManager.hyprland.settings.monitor = [
      "DP-1, 3840x2160, 0x0, 1"
      "DP-2, 3840x2160, 3840x0, 1"
    ];
    services = {
      printing.enable = true;
      syncnet.enable = true;
      borgbase.enable = true;
    };
    fonts.fontconfig.subpixel.rgba = "rgb";
    fonts.fontconfig.subpixel.lcdfilter = "default";
  };
}
