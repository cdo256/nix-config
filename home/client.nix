{ inputs, nix, config, lib, pkgs, nixpkgs, stdenv, ... }:

let
  symlink = config.lib.file.mkOutOfStoreSymlink;
  scriptsPackage = pkgs.callPackage ./scripts/default.nix {};
in
{
  imports = [
    inputs.nixvim.homeManagerModules.nixvim
    ./../modules/nixvim
  ];

  # Home Manager needs a bit of information about you and the paths it should
  # manage.
  home.username = "cdo";
  home.homeDirectory = "/home/cdo";

  # This value determines the Home Manager release that your configuration is
  # compatible with. This helps avoid breakage when a new Home Manager release
  # introduces backwards incompatible changes.
  #
  # You should not change this value, even if you update Home Manager. If you do
  # want to update the value, then make sure to first check the Home Manager
  # release notes.
  home.stateVersion = "24.05"; # Please read the comment before changing.

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
    TERMINAL = "alacritty";
    BASH_HISTORY = "${config.xdg.configHome}/shell/histfile";
    GNUPGHOME = "${config.home.homeDirectory}/.local/secure/gnupg";
    HISTFILE = "${config.xdg.stateHome}/shell/histfile";
    MAILDIR = "${config.xdg.dataHome}/mail/"; # Trailing slash required.
    SPACEMACSDIR = "${config.xdg.configHome}/spacemacs";
  };

  home.file = {
    "sync/.stignore" = {
      source = builtins.toFile "stignore" "
        s9
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
      source = ./files/sway;
      recursive = true;
    };
    ".config/spacemacs" = {
      source = ./files/spacemacs;
      recursive = true;
    };
    ".config/git".source = ./files/git;
    ".config/nvim" = {
      source = ./files/nvim;
      recursive = true;
    };
    ".thunderbird".source = symlink "/home/cdo/.config/thunderbird";
    ".mozilla/firefox".source = symlink "/home/cdo/.config/firefox";
  };

  # For Dolphin
  qt = {
    enable = true;
    platformTheme = "gnome";
    style = {
      name = "adwaita-dark";
    };
  };
  xdg.mimeApps.defaultApplications."inode/directory" =
      "org.kde.dolphin.desktop";

  programs.fish.enable = true;

  home.packages = [
    pkgs.fish
    pkgs.thunderbird
    pkgs.vim
    pkgs.keepassxc
    pkgs.nmon
    pkgs.alacritty
    pkgs.emacs
    pkgs.neovim
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
    pkgs.okular
    pkgs.vscodium
    pkgs.thunderbird
    pkgs.keepassxc
    pkgs.inkscape
    pkgs.gimp
    pkgs.nmap
    pkgs.xdg-desktop-portal
    pkgs.kdePackages.xdg-desktop-portal-kde 
    pkgs.kdePackages.kdenlive
    pkgs.kdePackages.dolphin
  ];
  services = {
    gammastep = {
      enable = true;
      provider = "manual";
      latitude = 51.5;
      longitude = -0.1;
    };
  };
  programs.home-manager.enable = true;
}
