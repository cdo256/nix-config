_: {
  home.stateVersion = "24.05"; # Do not change.
  nixpkgs.config.allowUnfree = true;
  programs.home-manager.enable = true;
  home.enableNixpkgsReleaseCheck = false; # suppress warning, since we are tracking nixos-unstable (via mutix)
}
