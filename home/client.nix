{ nix, config, lib, pkgs, nixpkgs, stdenv, ... }:

let
  symlink = config.lib.file.mkOutOfStoreSymlink;
  scriptsPackage = pkgs.callPackage ./scripts/default.nix {};
in
{
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
    EDITOR = "codium";
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
    ".thunderbird".source = symlink "/home/cdo/.config/thunderbird";
    ".mozilla/firefox".source = symlink "/home/cdo/.config/firefox";
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
    pkgs.vscodium
    pkgs.thunderbird
    pkgs.keepassxc
    pkgs.inkscape
    pkgs.gimp
    pkgs.nmap
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
