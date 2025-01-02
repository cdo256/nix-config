{
  nix,
  config,
  lib,
  pkgs,
  nixpkgs,
  stdenv,
  inputs,
  files,
  bootstrap,
  ...
}:

let
  scriptsPackage = pkgs.callPackage ./scripts/default.nix { };
in
{
  imports = [
    ./hardware-configuration.nix
    ../devices.nix
    ../../modules/syncnet.nix
    ../../modules/borgbase.nix
    ../../modules/sops.nix
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

    boot.loader.systemd-boot.enable = true;
    boot.loader.efi.canTouchEfiVariables = true;
    boot.kernelModules = [ "v4l2loopback" ];
    boot.extraModulePackages = with config.boot.kernelPackages; [
      v4l2loopback
    ];
    boot.extraModprobeConfig = ''
      options v4l2loopback devices=1 video_nr=1 card_label="OBS Cam" exclusive_caps=1
    '';

    networking.hostName = "peter";
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
    home-manager =
      if bootstrap then
        { }
      else
        {
          backupFileExtension = "nix.bak";
          extraSpecialArgs = {
            inherit inputs;
            inherit files;
          };
          users.cdo = import ../../home/client.nix;
        };

    environment = {
      systemPackages = [
        pkgs.vim # Do not forget to add an editor to edit configuration.nix! The Nano editor is also installed by default.
        pkgs.wget
        pkgs.git
        pkgs.guix
        pkgs.ungoogled-chromium
        #scriptsPackage
        pkgs.libimobiledevice
        pkgs.ifuse
        pkgs.usbmuxd
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

        # use the example session manager (no others are packaged yet so this is enabled by default,
        # no need to redefine it in your config for now)
        #media-session.enable = true;
      };
      syncnet.enable = true;
      syncnet.devices = config.devices;
      borgbase.enable = true;
      avahi = {
        enable = true;
        nssmdns4 = true;
      };
    };
    # systemd.services."restic-backups-borgbase" = {
    #   preStart = ''
    #     rm -rf /home/cdo/src-backup
    #     ${pkgs.rsync}/bin/rsync \
    #       -a --delete \
    #       --filter=':- .gitignore' \
    #       --link-dest=/home/cdo/src \
    #       /home/cdo/src/ /home/cdo/src-backup
    #   '';
    # };
  };
}
