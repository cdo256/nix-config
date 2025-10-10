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
  pkgs.obsidian
  pkgs.anki
  pkgs.zotero # Reference manager
  pkgs.ncpamixer
  pkgs.pavucontrol
  pkgs.discord
  pkgs.teams-for-linux

  # Broken
  pkgs.zoom # Screen sharing never worked, but browser sharing did.

  # Less used
  pkgs.signal-desktop
  pkgs.kdePackages.okular
  pkgs.inkscape
  pkgs.gimp
  pkgs.google-chrome
  pkgs.remmina # RDP client
]
