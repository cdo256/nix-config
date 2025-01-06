{
  inputs,
  nix,
  config,
  lib,
  pkgs,
  nixpkgs,
  stdenv,
  files,
  ...
}:

let
  symlink = config.lib.file.mkOutOfStoreSymlink;
  scriptsPackage = pkgs.callPackage ./scripts/default.nix { };
in
{
  imports = [
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

  programs.fish = {
    enable = true;
    loginShellInit = ''
      set -x PATH ~/.local/bin $PATH
      set -x GPG_TTY (tty)
      set -g fish_key_bindings fish_vi_key_bindings
      direnv hook fish | source
    '';
  };

  home.packages = [
    # Stable
    pkgs.fish
    pkgs.fzf
    pkgs.fishPlugins.foreign-env
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

    # Trying
    pkgs.fishPlugins.done
    pkgs.fishPlugins.autopair
    pkgs.fishPlugins.fzf-fish
    pkgs.fishPlugins.forgit
    pkgs.fishPlugins.hydro
    pkgs.grc
    pkgs.fishPlugins.grc
    pkgs.delta
  ];

  nixpkgs.config.allowUnfree = true;
  programs.home-manager.enable = true;
}
