{ pkgs, inputs, ... }:
[
  pkgs.nixfmt-rfc-style
  pkgs.jq
  pkgs.just
  pkgs.git
  pkgs.lazygit
  pkgs.git-imerge
  pkgs.git-filter-repo
  pkgs.gh
  pkgs.gitleaks
  pkgs.mergiraf
  pkgs.nixvim
  pkgs.delta
  pkgs.zed-editor

  # Less used
  pkgs.vscodium
  pkgs.emacs

  # Trying
  pkgs.jujutsu # 'better' git
]
