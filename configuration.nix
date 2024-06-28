{ nix, config, lib, pkgs, nixpkgs, ... }:

let
  scriptsPackage = pkgs.callPackage ./scripts/default.nix {};
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
      # GNUPGHOME = "${config.home.homeDirectory}/.local/secure/gnupg";
      # HISTFILE = "${xdg.stateHome}/shell/histfile";
      # MAILDIR = "${xdg.dataHome}/mail/"; # Trailing slash required.
      SPACEMACSDIR = "${config.xdg.configHome}/spacemacs";
    }; 

    home.file = {
      "sync" = {
        source = symlink /mnt/guix-home/cdo/sync;
      };
      #".config/fish" = {
      #  source = /mnt/guix-home/cdo/src/config-files/fish;
      #  recursive = true;
      #};
      ".config/sway" = {
        source = /mnt/guix-home/cdo/src/config-files/sway;
        recursive = true;
      };
      ".config/spacemacs" = {
        source = /mnt/guix-home/cdo/src/config-files/spacemacs;
        recursive = true;
      };
      ".config/git".source = /mnt/guix-home/cdo/src/config-files/git;
      ".config/nvim" = {
        source = /mnt/guix-home/cdo/src/config-files/nvim;
        recursive = true;
      };
      ".config/chromium" = {
        source = symlink /mnt/guix-home/cdo/.config/chromium;
      };
      ".config/spacemacs/custom.el" = {
        source = symlink /mnt/guix-home/cdo/.config/spacemacs/custom.el;
      };
      # ".config/emacs" = {
      #   recursive = true;
      #   source = pkgs.fetchgit {
      #     url = "https://github.com/syl20bnr/spacemacs.git";
      #     fetchSubmodules = false;
      #     hash = "sha256-9/nvRhXJK+PjvglHmPu5RiJbfAz7XqkX9oHTo7LfIFI=";
      #   };
      # };
      ".config/libreoffice".source = symlink /mnt/guix-home/cdo/.config/libreoffice;
      ".config/obs-studio" = {
        source = symlink /mnt/guix-home/cdo/.config/obs-studio;
      };
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

    # home.file.".config/emacs" = {
    #   recursive = true;
    #   source = pkgs.fetchgit {
    #     url = "https://github.com/syl20bnr/spacemacs.git";
    #     fetchSubmodules = false;
    #   };
    programs.fish.enable = true;

    home.packages = [
      pkgs.fish
      pkgs.thunderbird
      pkgs.vim
      pkgs.keepassxc
      pkgs.git      
      pkgs.ungoogled-chromium
      pkgs.nmon
      pkgs.alacritty
      pkgs.emacs
      pkgs.zoom
      pkgs.vscodium
      pkgs.direnv
      pkgs.obs-studio
      pkgs.ffmpeg_7-full
      pkgs.borgbackup
      pkgs.libreoffice
      pkgs.vlc
      pkgs.signal-desktop
   ];
 };

  # List packages installed in system profile. To search, run:
  # $ nix search wget
  environment.systemPackages = [
    pkgs.vim # Do not forget to add an editor to edit configuration.nix! The Nano editor is also installed by default.
    pkgs.wget
    pkgs.git
    pkgs.guix
    #scriptsPackage
  ];

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
    # borgbackup.jobs.home-cdo = {
    #   paths = "/home/cdo";
    #   encryption.mode = "repokey";
    #   encryption.passCommand = "cat /run/keys/borg-pass";
    #   doInit = true;
    #   environment = { BORG_RSH = "ssh -i /run/keys/id_borg"; };
    # };
     
  }; 
}
