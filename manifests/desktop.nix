{ pkgs, ... }:
[
  pkgs.thunderbird
  pkgs.keepassxc
  pkgs.kitty
  pkgs.obs-studio
  pkgs.ffmpeg_7-full
  pkgs.libreoffice
  pkgs.vlc
  pkgs.xdg-desktop-portal
  pkgs.google-chrome
  pkgs.brave
  pkgs.obsidian
  pkgs.anki

  # Broken
  pkgs.zoom # Screen sharing never worked, but browser sharing did.

  # Less used
  pkgs.vscodium
  pkgs.emacs
  pkgs.signal-desktop
  pkgs.okular
  pkgs.inkscape
  pkgs.gimp

  # Trying
  pkgs.zotero # Reference manager
  pkgs.ncpamixer
  pkgs.pavucontrol
]
