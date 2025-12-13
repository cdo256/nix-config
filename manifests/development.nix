{ pkgs, self', ... }:
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
  pkgs.cloc
  pkgs.nixd # Nix language server
  #pkgs.zed-editor-fhs
  self'.packages.just-agda
  self'.packages.git-reflection

  # Less used
  pkgs.vscodium
  pkgs.emacs

  # Trying
  pkgs.jujutsu # 'better' git
]
