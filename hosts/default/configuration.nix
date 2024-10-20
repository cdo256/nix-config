{ nix, config, lib, pkgs, nixpkgs, stdenv, inputs, ... }:

let
  scriptsPackage = pkgs.callPackage ./scripts/default.nix {};
in
{
  nixpkgs.config.allowUnfree = true;
  nix.settings.experimental-features = [ "nix-command" "flakes" ];
  imports =
    [ # Include the results of the hardware scan.
      #./hardware-configuration.nix
      inputs.home-manager.nixosModules.default
    ];

  # Before changing this value read the documentation for this option
  # (e.g. man configuration.nix or on https://nixos.org/nixos/options.html).
  system.stateVersion = "24.05";

  boot.loader.grub.enable = true;
  boot.loader.grub.device = "/dev/nvme0n1";
  boot.loader.grub.useOSProber = true;

  boot.initrd.luks.devices."luks-58655766-776f-42ca-96b1-a87a3e21508f".device = "/dev/disk/by-uuid/58655766-776f-42ca-96b1-a87a3e21508f";
  # Setup keyfile
  boot.initrd.secrets = {
    "/boot/crypto_keyfile.bin" = null;
  };

  boot.loader.grub.enableCryptodisk = true;

  boot.initrd.luks.devices."luks-26f30444-e729-4254-808d-16e12eec659f".keyFile = "/boot/crypto_keyfile.bin";
  boot.initrd.luks.devices."luks-58655766-776f-42ca-96b1-a87a3e21508f".keyFile = "/boot/crypto_keyfile.bin";
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
    enable =  true;
  };

  users.users.cdo = {
    uid = 1000;
    isNormalUser = true;
    description = "Christina O'Donnell";
    extraGroups = [ "networkmanager" "wheel" ];
    packages = with pkgs; [
    ];
    shell = pkgs.fish;
  };

  home-manager = {
    extraSpecialArgs = { inherit inputs; };
    users.cdo = import ./home.nix;
  };

  environment = {
    systemPackages = [
      pkgs.vim # Do not forget to add an editor to edit configuration.nix! The Nano editor is also installed by default.
      pkgs.wget
      pkgs.git
      pkgs.ungoogled-chromium
      #pkgs.guix
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
    logind = {
      lidSwitch = "ignore";
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

      # use the example session manager (no others are packaged yet so this is enabled by default,
      # no need to redefine it in your config for now)
      #media-session.enable = true;
    };
    restic = {
      backups.borgbase = {
        repository = "";
        initialize = true;
        passwordFile = "/var/restic/borgbase.pass";
        paths = [ "/home" "/var" ];
        extraBackupArgs = let
          ignorePatterns = [
            "/home/*/.local/share/trash"
            "/home/*/src"
            "/home/*/.local"
            ".cache"
            ".tmp"
            ".log"
            ".Trash"
          ];
          ignoreFile = builtins.toFile "ignore"
            (lib.lists.foldl (a: b: a + "\n" + b) "" ignorePatterns);
        in [
          "--exclude-file=${ignoreFile}"
          "-vv"
        ];
        pruneOpts = [
          "--keep-daily 7"
          "--keep-weekly 4"
          "--keep-monthly 3"
          "--keep-yearly 1"
        ];
      };
    };
    #   paths = "/home/cdo";
    #   encryption.mode = "repokey";
    #   encryption.passCommand = "cat /run/keys/borg-pass";
    #   doInit = true;
    #   environment = { BORG_RSH = "ssh -i /run/keys/id_borg"; };
    # };
    syncthing = {
      enable = true;
      user = "cdo";
      dataDir = "/home/cdo/";
      configDir = "/home/cdo/.config/syncthing";
      overrideDevices = true;
      overrideFolders = true;
      settings = {
        devices = {
          "peter" = { id = "5B7GQEP-LCS4VN6-N3LORSY-24NTMW3-AJ6DVUE-T2CFXIH-7EITS46-ZFBXWAD"; };
          "isaac" = { id = "RHYO6AW-JYA36ML-PZD4MX2-WVEJUFM-FLV5WNS-66FNKJE-F4AHMT5-COI32QC"; };
          "a34" = { id = "RYS4YUR-ZYVE46Q-NBUAAKM-I7TX46Z-JSM367B-RGCIYTY-TC6TVV6-GYWSPAF"; };
          "halley" = { id = "5B7GQEP-LCS4VN6-N3LORSY-24NTMW3-AJ6DVUE-T2CFXIH-7EITS46-ZFBXWAD"; };
          "s9" = { id = "X4EZQ7E-ZD5KA3Q-XVU77YT-KDJIBZ4-FMMMSW7-5V6IMMI-VQEHC5O-4ZBEMA5"; };
        };
        folders = {
          "sync" = {
            path = "/home/cdo/sync";
            devices = [ "peter" "isaac" "s9" "halley" "a34" ];
            versioning = {
              type = "staggered";
              params.maxAge = 365;
            };
          };
          "org" = {
            path = "/home/cdo/sync/org";
            devices = [ "peter" "a34" ];
            versioning = {
              type = "staggered";
              params.maxAge = 365;
            };
          };
          #"org-roam" = {
          #  path = "/home/cdo/org-roam";
          #  devices = [ "peter" "isaac" "a34" ];
          #  versioning = {
          #    type = "staggered";
          #    params.maxAge = 365;
          #  };
          #};
          "a34-root" = {
            path = "/home/cdo/sync/a34";
            devices = [ "peter" "a34" "halley" "isaac" ];
            versioning = {
              type = "staggered";
              params.maxAge = 365;
            };
          };
          "s9-root" = {
            path = "/home/cdo/sync/s9";
            devices = [ "peter" "s9" ];
            versioning = {
              type = "staggered";
              params.maxAge = 365;
            };
          };
          "secure" = {
            path = "/home/cdo/sync/secure";
            devices = [ "peter" "isaac" "a34" "halley" "s9" ];
            versioning = {
              type = "staggered";
              params.maxAge = 365;
            };
          };
        };
      };
    };
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
}
