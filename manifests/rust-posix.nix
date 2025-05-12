{ pkgs, ... }:
[
  # Not stable yet.
  pkgs.sudo-rs # memory-safe `sudo`
  pkgs.uutils-coreutils-noprefix # replaces GNU `coreutils`
]
