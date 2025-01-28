{
  self,
  nix,
  config,
  lib,
  pkgs,
  nixpkgs,
  stdenv,
  inputs,
  #files,
  flake,
  ...
}:
let
  packages = flake.lib.mkPackageList {
    modules = [
      #"/base.nix"
      #"/system.nix"
    ];
    inherit (config.nixpkgs.hostPlatform) system;
  };
in
{
  imports = [
    #../devices.nix
    #../../os-modules/syncnet.nix
    #../../os-modules/borgbase.nix
    #../../os-modules/sops.nix
    #inputs.home-manager.nixosModules.default
  ];

  config = {
    system.stateVersion = "24.05";

    console.keyMap = "uk";
    hardware.pulseaudio.enable = false;

    #home-manager = {
    #  backupFileExtension = "nix.bak";
    #  extraSpecialArgs = {
    #    inherit inputs;
    #    #inherit files;
    #    extraImports = [ ];
    #  };
    #  users.cdo = import ../../home/client.nix;
    #};

    xdg.portal = {
      enable = true;
      extraPortals = [ pkgs.kdePackages.xdg-desktop-portal-kde ];
      config.common.default = [
        "kde"
      ];
    };

    environment = {
      systemPackages = packages;
    };

    #programs.mtr.enable = true;
    programs = {
      gnupg.agent = {
        enable = true;
        enableSSHSupport = true;
      };
      sway.enable = true;
      fish.enable = true;
      firefox.enable = true;
    };

    services = {
      logind = {
        lidSwitch = "ignore";
        powerKey = "suspend";
      };
      xserver = {
        enable = true;
        displayManager.gdm.enable = true;
        displayManager.gdm.wayland = true;
        desktopManager.gnome.enable = true;
        xkb.layout = "gb";
        xkb.variant = "";
      };
      libinput.enable = true;
      openssh.enable = true;
      printing.enable = true;
      pipewire = {
        enable = true;
        alsa.enable = true;
        alsa.support32Bit = true;
        pulse.enable = true;
      };
      #borgbase.enable = false;
      #syncnet.enable = true;
      #syncnet.devices = config.devices;
      avahi = {
        enable = true;
        nssmdns4 = true;
      };
    };
  };
}
