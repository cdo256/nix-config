{ pkgs, inputs, ... }:
[
  pkgs.nixfmt-rfc-style
  pkgs.jq
  pkgs.lazygit
  pkgs.git-imerge
  inputs.nixvim.packages.x86_64-linux.default
  pkgs.delta
  pkgs.zed-editor
  pkgs.just # updated gnumake replacement

  # Less used
  pkgs.vscodium
  pkgs.emacs

  # Trying
  pkgs.jujutsu # better git
]
