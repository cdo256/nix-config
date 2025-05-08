{
  config,
  ...
}:
{
  config = {
    home-manager.users.${config.args.owner}.wayland.windowManager.hyprland.settings.monitor = [
      "DP-1, 1920x1080, 0x0, 1"
    ];
    services = {
      printing.enable = true;
      syncnet.enable = true;
      borgbase.enable = true;
    };
    fonts.fontconfig.subpixel.rgba = "rgb";
    fonts.fontconfig.subpixel.lcdfilter = "default";
    hardware.video.hidpi.enable = true;
    fonts.optimizeForVeryHighDPI = true;
  };
}
