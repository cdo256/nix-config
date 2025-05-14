{
  inputs,
  arch,
  pkgs,
  ...
}:
[
  pkgs.ifuse
  pkgs.usbmuxd
  pkgs.restic
  pkgs.nmap
  pkgs.nvd
  pkgs.nix-output-monitor
  pkgs.powertop
  pkgs.powerstat
  pkgs.htop
  pkgs.btop
  pkgs.nmon
  pkgs.wavemon
  pkgs.mtr
  pkgs.dig
  pkgs.sysstat
  pkgs.inetutils
  pkgs.nh
  pkgs.isd
  pkgs.nettools
  pkgs.arp-scan
  pkgs.netbird

  # Trying
  pkgs.bottom # btm ~ better top, htop, etc
  pkgs.broot # interactive directory navigation
  pkgs.cyme # better `lsusb`
  pkgs.dua # disk usage, interactively
  pkgs.hexyl # hex pretty printer
  pkgs.iotop # io top
  pkgs.procs # better ps
  #pkgs.sudo-rs # memory-safe `sudo`
  #pkgs.uutils-coreutils-noprefix # replaces GNU `coreutils`
  pkgs.viddy # better watch
]
