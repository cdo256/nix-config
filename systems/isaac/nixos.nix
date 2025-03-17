{
  config,
  ...
}:
{
  config = {
    home-manager.users.${config.args.owner}.wayland.windowManager.hyprland.settings.monitor = [
      #TODO
      #"eDP-1, 1920x1080, 0x0, 1"
    ];
    services = {
      printing.enable = true;
      syncnet.enable = true;
      borgbase.enable = true;
    };
  };
}
