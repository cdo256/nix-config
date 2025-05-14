{ pkgs, inputs, ... }:
[
  pkgs.nixfmt-rfc-style
  pkgs.jq
  pkgs.lazygit
  pkgs.git-imerge
  pkgs.nixvim
  pkgs.delta
  pkgs.zed-editor
  pkgs.just # updated gnumake replacement

  # Less used
  pkgs.vscodium
  pkgs.emacs

  # Trying
  pkgs.jujutsu # better git
]
