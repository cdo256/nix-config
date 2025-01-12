{
  inputs,
  nix,
  config,
  lib,
  pkgs,
  nixpkgs,
  stdenv,
  files,
  extraImports,
  ...
}:

let
  symlink = config.lib.file.mkOutOfStoreSymlink;
  scriptsPackage = pkgs.callPackage ./scripts/default.nix { };
in
{
  imports = [
    ./fish.nix
  ] ++ extraImports;

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
    EDITOR = "nvim";
    TERMINAL = "alacritty";
    BASH_HISTORY = "${config.xdg.configHome}/shell/histfile";
    GNUPGHOME = "${config.home.homeDirectory}/.local/secure/gnupg";
    HISTFILE = "${config.xdg.stateHome}/shell/histfile";
    MAILDIR = "${config.xdg.dataHome}/mail/"; # Trailing slash required.
    SPACEMACSDIR = "${config.xdg.configHome}/spacemacs";
  };

  home.file = {
    ".config/spacemacs" = {
      source = "${files}/spacemacs";
      recursive = true;
    };
    ".config/git" = {
      source = "${files}/git";
      recursive = true;
    };
    #".config/nvim" = {
    #  source = "${files}/nvim";
    #  recursive = true;
    #};
  };

  # For Dolphin

  home.packages = [
    # Stable
    pkgs.vim # In a pinch
    pkgs.nmon
    pkgs.direnv
    pkgs.restic
    pkgs.trash-cli
    pkgs.nmap
    pkgs.nh # NixOS Helper
    pkgs.nixfmt-rfc-style
    pkgs.nix-output-monitor
    pkgs.nvd
    pkgs.jq
    pkgs.moreutils
    inputs.nixvim.packages.x86_64-linux.default
    pkgs.just
    pkgs.lazygit
    pkgs.htop

    # Trying
    pkgs.delta
    pkgs.git-imerge
  ];

  nixpkgs.config.allowUnfree = true;
  programs.home-manager.enable = true;
}
