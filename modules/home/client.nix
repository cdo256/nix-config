{
  inputs,
  nix,
  config,
  lib,
  pkgs,
  args,
  nixpkgs,
  stdenv,
  #files,
  ...
}:

let
  symlink = config.lib.file.mkOutOfStoreSymlink;
  scriptsPackage = pkgs.callPackage ./scripts/default.nix { };
in
{
  home.username = "cdo";
  home.stateVersion = "24.05"; # Please read the comment before changing.

  home.sessionVariables = {
    EDITOR = "${inputs.nixvim.packages.${args.arch}.default}/bin/nvim";
    BROWSER = "${pkgs.brave}/bin/brave";
    TERMINAL = "${pkgs.kitty}/bin/kitty";
  };

  home.packages = [
    # Stable
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
    pkgs.brave

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
    pkgs.file

    # Trying
    pkgs.delta
    pkgs.git-imerge
    pkgs.obsidian
    pkgs.zotero # Reference manager
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
