{
  inputs,
  nix,
  config,
  lib,
  pkgs,
  nixpkgs,
  stdenv,
  files,
  extraImports ? [ ],
  ...
}:

let
  symlink = config.lib.file.mkOutOfStoreSymlink;
  scriptsPackage = pkgs.callPackage ./scripts/default.nix { };
in
{
  imports = [
    ./hyprland.nix
    ./hyprpanel.nix
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
    BROWSER = "brave";
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
    ".config/sway" = {
      source = "${files}/sway";
      recursive = true;
    };
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
    ".config/obs-studio" = {
      source = "${files}/obs-studio";
      recursive = true;
    };
    #".config/hypr" = {
    #  source = "${files}/hypr";
    #  recursive = true;
    #};

    ".thunderbird".source = symlink "/home/cdo/.config/thunderbird";
    ".mozilla/firefox".source = symlink "/home/cdo/.config/firefox";
  };

  # For Dolphin
  qt = {
    enable = true;
    platformTheme.name = "adwaita";
    style = {
      name = "adwaita-dark";
    };
  };
  xdg.mimeApps.defaultApplications."inode/directory" = "org.kde.dolphin.desktop";

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
    pkgs.thunderbird
    pkgs.vim # In a pinch
    pkgs.keepassxc
    pkgs.nmon
    pkgs.alacritty
    pkgs.direnv
    pkgs.obs-studio
    pkgs.ffmpeg_7-full
    pkgs.restic
    pkgs.libreoffice
    pkgs.vlc
    pkgs.trash-cli
    pkgs.nmap
    pkgs.xdg-desktop-portal
    pkgs.nh # NixOS Helper
    pkgs.nixfmt-rfc-style
    pkgs.nix-output-monitor
    pkgs.nvd
    pkgs.jq
    pkgs.moreutils
    inputs.nixvim.packages.x86_64-linux.default
    pkgs.just
    pkgs.lazygit
    pkgs.google-chrome
    pkgs.htop

    # Broken
    pkgs.zoom # Screen sharing never worked, but browser sharing did.

    pkgs.kdePackages.xdg-desktop-portal-kde
    pkgs.kdePackages.kdenlive
    pkgs.kdePackages.dolphin # Usable but dark color-scheme is broken.

    # Less used
    pkgs.vscodium
    pkgs.emacs
    pkgs.signal-desktop
    pkgs.okular
    pkgs.inkscape
    pkgs.gimp

    # Trying
    pkgs.fishPlugins.done
    pkgs.fishPlugins.autopair
    pkgs.fishPlugins.fzf-fish
    pkgs.fishPlugins.forgit
    pkgs.fishPlugins.hydro
    pkgs.grc
    pkgs.fishPlugins.grc
    pkgs.brave
    pkgs.delta
    pkgs.git-imerge
    pkgs.obsidian
  ];
  services = {
    gammastep = {
      enable = true;
      provider = "manual";
      latitude = 51.5;
      longitude = -0.1;
    };
  };

  nixpkgs.config.allowUnfree = true;
  programs.home-manager.enable = true;
}
