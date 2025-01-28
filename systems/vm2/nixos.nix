{
  nix,
  config,
  lib,
  pkgs,
  nixpkgs,
  stdenv,
  inputs,
  #files,
  ...
}:

#let
#  scriptsPackage = pkgs.callPackage ./scripts/default.nix { };
#in
{
  imports = [
    #../devices.nix
    #../../os-modules/syncnet.nix
    #../../os-modules/borgbase.nix
    #../../os-modules/sops.nix
    #inputs.home-manager.nixosModules.default
  ];

  config = {
    #nixpkgs.config.allowUnfree = true;
    #nix = {
    #  settings.experimental-features = [
    #    "nix-command"
    #    "flakes"
    #  ];
    #};

    system.stateVersion = "24.05";

    # From hardware-configuration.nix
    nixpkgs.hostPlatform = lib.mkDefault "x86_64-linux";

    virtualisation.vmVariant = {
      virtualisation = {
        memorySize = 2048;
        cores = 2;
        graphics = false;
      };
    };

    networking.hostName = "vm2";
    networking.wireless.enable = false;

    # Enable networking
    networking.networkmanager.enable = true;

    # Set your time zone.
    time.timeZone = "Europe/London";

    # Select internationalisation properties.
    i18n.defaultLocale = "en_GB.UTF-8";

    i18n.extraLocaleSettings = {
      LC_ADDRESS = "en_GB.UTF-8";
      LC_IDENTIFICATION = "en_GB.UTF-8";
      LC_MEASUREMENT = "en_GB.UTF-8";
      LC_MONETARY = "en_GB.UTF-8";
      LC_NAME = "en_GB.UTF-8";
      LC_NUMERIC = "en_GB.UTF-8";
      LC_PAPER = "en_GB.UTF-8";
      LC_TELEPHONE = "en_GB.UTF-8";
      LC_TIME = "en_GB.UTF-8";
    };

    console.keyMap = "uk";
    hardware.pulseaudio.enable = false;
    security.rtkit.enable = true;
    security.polkit.enable = true;
    security.sudo = {
      enable = true;
      wheelNeedsPassword = false;
    };

    users.users.root.initialPassword = "";
    users.users.cdo = {
      uid = 1000;
      isNormalUser = true;
      description = "Christina O'Donnell";
      extraGroups = [
        "networkmanager"
        "wheel"
      ];
      initialPassword = "";
      packages = with pkgs; [
      ];
      shell = pkgs.fish;
    };

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
      systemPackages = [
        pkgs.vim
        pkgs.wget
        pkgs.git
        pkgs.ungoogled-chromium
        #scriptsPackage
        pkgs.libimobiledevice
        pkgs.ifuse
        pkgs.usbmuxd
        pkgs.kdePackages.dolphin
        pkgs.kdePackages.qtwayland
      ];
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
