{
  self,
  config,
  pkgs,
  inputs,
  #files,
  ...
}:
{
  imports = [
    #  ../devices.nix
    #  ../../os-modules/syncnet.nix
    #  ../../os-modules/borgbase.nix
    #  ../../os-modules/sops.nix
    #  inputs.sops-nix.nixosModules.sops
  ];

  config = {
    home-manager.users.${config.args.owner}.wayland.windowManager.hyprland.settings.monitor = [
      "eDP-1, 1920x1080, 0x0, 1"
    ];
    services = {
      printing.enable = true;
      #borgbase.enable = true;on wayland, should I configure libinput exclusively or will I also need to configure xkb (for cases where I'm using an x-wayland applicaiton?
      #syncnet.enable = true;
      #syncnet.devices = config.devices;
    };
  };
}
