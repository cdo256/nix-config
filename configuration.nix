{ nix, config, lib, pkgs, nixpkgs, stdenv, ... }:

let
  scriptsPackage = pkgs.callPackage ./scripts/default.nix {};
  pynentry = pkgs.python3Packages.buildPythonPackage rec {
    pname = "pynentry";
    version = "0.0.1";
    src = pkgs.fetchFromGitHub {
      owner = "Laharah";
      repo = "pynentry";
      rev = "master";
      sha256 = "Pu7lMgMEHYTP/6yvkt0QsyLPNQvYbj7el7EGKXUA/cQ=";
    };
    dependencies = [
      pkgs.pinentry
    ];
    propagatedBuildInputs = [
      (pkgs.python3.withPackages (pypkgs: [
        pypkgs.setuptools
        pypkgs.setuptools-scm
        #pypkgs.subprocess
        #pypkgs.os
        #pypkgs.sys
        #pypkgs.re
        #pypkgs.locale
      ]))
    ];
    meta = {
      description = "A pythonic wrapper for pinentry";
      homepage = "https://github.com/Laharah/pynentry";
      license = lib.licenses.mit;
    };
    doCheck = false; # Requires tty
  };
  askpass = pkgs.stdenv.mkDerivation {
    name = "askpass";
  
    propagatedBuildInputs = [
      (pkgs.python3.withPackages (pypkgs: [
        pynentry
        pkgs.pinentry-gnome3
        pypkgs.ipdb
      ]))
    ];
    dontUnpack = true;
    installPhase = "install -Dm755 ${pkgs.writeText "askpass.py" ''
      #!/usr/bin/env python3
      from pynentry import *
      import sys

      pinentry = "${pkgs.pinentry-gnome3}/bin/pinentry-gnome3"

      with PynEntry(executable=pinentry) as pe:
          pe.prompt = "Enter password for sudo:"
          try:
              pw = pe.get_pin()
              print(pw)
              exit(0)
          except PinEntryCancelled as e:
              print("Cancelled.", file=sys.stderr)
              exit(2)
          except Exception as e:
              print(e, file=sys.stderr)
              exit(1)
    ''} $out/bin/askpass";
  };
in
{
  nixpkgs.config.allowUnfree = true;
  nix.settings.experimental-features = [ "nix-command" "flakes" ];
  imports =
    [ # Include the results of the hardware scan.
      ./hardware-configuration.nix
      <home-manager/nixos>
    ];

  # Before changing this value read the documentation for this option
  # (e.g. man configuration.nix or on https://nixos.org/nixos/options.html).
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

  home-manager.useUserPackages = true;
  home-manager.users.cdo = { pkgs, config, lib, ... }:
  let
    symlink = config.lib.file.mkOutOfStoreSymlink;
  in
  {
    home.stateVersion = "24.05";
    home.username = "cdo";
    home.homeDirectory = "/home/cdo";
    programs.home-manager.enable = true;
    xdg.enable = true;
    xdg.userDirs = {
      enable = true;
      download = "/home/cdo/downloads";
      pictures = "/home/cdo/images";
      templates = "/home/cdo";
      videos = "/home/cdo";
      desktop = "/home/cdo";
      documents = "/home/cdo";
      music = "/home/cdo";
      createDirectories = true;
    };
    home.sessionVariables = {
      BROWSER = "chromium";
      EDITOR = "vim"; # TODO: Change to emacsclient once I've set up the emacs server.
      TERMINAL = "alacritty";
      BASH_HISTORY = "${config.xdg.configHome}/shell/histfile";
      GNUPGHOME = "${config.home.homeDirectory}/.local/secure/gnupg";
      HISTFILE = "${xdg.stateHome}/shell/histfile";
      MAILDIR = "${xdg.dataHome}/mail/"; # Trailing slash required.
      SPACEMACSDIR = "${config.xdg.configHome}/spacemacs";
    };

    home.file = {
      "sync/.stignore" = {
        source = builtins.toFile "stignore" "
          a34
          org
          org-roam
          secure
        ";
      };
      #".config/fish" = {
      #  source = /home/cdo/src/config-files/fish;
      #  recursive = true;
      #};
      ".config/sway" = {
        source = /home/cdo/src/config-files/sway;
        recursive = true;
      };
      ".config/spacemacs" = {
        source = /home/cdo/src/config-files/spacemacs;
        recursive = true;
      };
      ".config/git".source = /home/cdo/src/config-files/git;
      ".config/nvim" = {
        source = /home/cdo/src/config-files/nvim;
        recursive = true;
      };
      # ".config/emacs" = {
      #   recursive = true;
      #   source = pkgs.fetchgit {
      #     url = "https://github.com/syl20bnr/spacemacs.git";
      #     fetchSubmodules = false;
      #     hash = "sha256-9/nvRhXJK+PjvglHmPu5RiJbfAz7XqkX9oHTo7LfIFI=";
      #   };
      # };
      ".config/libreoffice".source = symlink /home/cdo/.config/libreoffice;
      ".config/keepassxc".source = /mnt/guix-home/cdo/.config/keepassxc;
      ".config/Signal".source = /mnt/guix-home/cdo/.config/Signal;
      ".config/swaylock".source = /mnt/guix-home/cdo/.config/swaylock;
      ".config/Synergy".source = /mnt/guix-home/cdo/.config/Synergy;
      ".config/VSCodium".source = /mnt/guix-home/cdo/.config/VSCodium;
      ".config/zoom.conf".source = /mnt/guix-home/cdo/.config/zoom.conf;
      ".config/zoomus.conf".source = /mnt/guix-home/cdo/.config/zoomus.conf;
      ".config/Yubico".source = /mnt/guix-home/cdo/.config/Yubico;
      ".config/x11".source = /mnt/guix-home/cdo/.config/x11;
    };

    programs.fish.enable = true;

    home.packages = [
      pkgs.fish
      pkgs.thunderbird
      pkgs.vim
      pkgs.keepassxc
      pkgs.nmon
      pkgs.alacritty
      pkgs.emacs
      pkgs.zoom
      pkgs.vscodium
      pkgs.direnv
      pkgs.obs-studio
      pkgs.ffmpeg_7-full
      pkgs.restic
      pkgs.libreoffice
      pkgs.vlc
      pkgs.signal-desktop
      pkgs.trash-cli
      pkgs.kdePackages.kdenlive
      pkgs.okular
   ];
   services = {
     gammastep = {
       enable = true;
       provider = "manual";
       latitude = 51.5;
       longitude = -0.1;
     };
   };
 };

  environment = {
    systemPackages = [
      pkgs.vim # Do not forget to add an editor to edit configuration.nix! The Nano editor is also installed by default.
      pkgs.wget
      pkgs.git
      pkgs.ungoogled-chromium
      pkgs.guix
      #scriptsPackage
      pkgs.libimobiledevice
      pkgs.ifuse
      pkgs.usbmuxd
    ];
    etc = {
      "sudo.conf" = {
        text = ''
          Path askpass ${askpass}/bin/askpass
        '';
        mode = "0400";
      };
    };
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
        };
        folders = {
          "sync" = {
            path = "/home/cdo/sync";
            devices = [ "peter" "isaac" ];
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
          "org-roam" = {
            path = "/home/cdo/org-roam";
            devices = [ "peter" "isaac" "a34" ];
            versioning = {
              type = "staggered";
              params.maxAge = 365;
            };
          };
          "a34-root" = {
            path = "/home/cdo/sync/a34";
            devices = [ "peter" "a34" ];
            versioning = {
              type = "staggered";
              params.maxAge = 365;
            };
          };
          "secure" = {
            path = "/home/cdo/sync/secure";
            devices = [ "peter" "isaac" "a34" ];
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
