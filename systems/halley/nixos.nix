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
    #  ../../os-modules/hyprland.nix
    #  ../../os-modules/fonts.nix
    #  inputs.sops-nix.nixosModules.sops
  ];

  config = {
    services = {
      xserver = {
        xkb.model = "";
      };
      printing.enable = true;
      #borgbase.enable = true;on wayland, should I configure libinput exclusively or will I also need to configure xkb (for cases where I'm using an x-wayland applicaiton?
      #syncnet.enable = true;
      #syncnet.devices = config.devices;
    };
  };
}
