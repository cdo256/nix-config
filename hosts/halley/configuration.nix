{
  nix,
  config,
  lib,
  pkgs,
  nixpkgs,
  stdenv,
  inputs,
  files,
  ...
}:

let
  scriptsPackage = pkgs.callPackage ./scripts/default.nix { };
in
{
  imports = [
    ./hardware-configuration.nix
    ../devices.nix
    ../../os-modules/syncnet.nix
    ../../os-modules/borgbase.nix
    ../../os-modules/sops.nix
    ../../os-modules/hyprland.nix
    ../../os-modules/fonts.nix
    inputs.home-manager.nixosModules.default
    inputs.sops-nix.nixosModules.sops
  ];

  config = {
    nixpkgs.config.allowUnfree = true;
    nix = {
      settings.experimental-features = [
        "nix-command"
        "flakes"
      ];
    };

    system.stateVersion = "24.05";

    boot.loader.grub.enable = true;
    boot.loader.grub.device = "/dev/nvme0n1";
    boot.loader.grub.useOSProber = true;

    boot.initrd.luks.devices."luks-58655766-776f-42ca-96b1-a87a3e21508f".device =
      "/dev/disk/by-uuid/58655766-776f-42ca-96b1-a87a3e21508f";
    # Setup keyfile
    boot.initrd.secrets = {
      "/boot/crypto_keyfile.bin" = null;
    };

    boot.loader.grub.enableCryptodisk = true;

    boot.initrd.luks.devices."luks-26f30444-e729-4254-808d-16e12eec659f".keyFile =
      "/boot/crypto_keyfile.bin";
    boot.initrd.luks.devices."luks-58655766-776f-42ca-96b1-a87a3e21508f".keyFile =
      "/boot/crypto_keyfile.bin";
    # networking.wireless.enable = true;  # Enables wireless support via wpa_supplicant.

    boot.kernelModules = [ "v4l2loopback" ];
    boot.extraModulePackages = with config.boot.kernelPackages; [
      v4l2loopback
    ];
    boot.extraModprobeConfig = ''
      options v4l2loopback devices=1 video_nr=1 card_label="OBS Cam" exclusive_caps=1
    '';

    networking.hostName = "halley";
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

    users.users.cdo = {
      uid = 1000;
      isNormalUser = true;
      description = "Christina O'Donnell";
      extraGroups = [
        "networkmanager"
        "wheel"
      ];
      packages = with pkgs; [
      ];
      shell = pkgs.fish;
    };

    home-manager = {
      backupFileExtension = "nix.bak";
      extraSpecialArgs = {
        inherit inputs;
        inherit files;
        extraImports = [ ];
      };
      users.cdo = import ../../home/client.nix;
    };

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
        desktopManager.gnome.enable = false;
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
      borgbase.enable = true;
      syncnet.enable = true;
      syncnet.devices = config.devices;
      avahi = {
        enable = true;
        nssmdns4 = true;
      };
      openvpn = {
        servers.surfshark = {
          config = ''
            config /etc/openvpn/uk-man.prod.surfshark.com_tcp.ovpn
            auth-user-pass /etc/openvpn/surfshark.pass
          '';
        };
      };
    };
  };
}
