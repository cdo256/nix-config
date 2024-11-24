{ inputs, nixpkgs, ... }:

{
  imports = [
    inputs.nixvim.homeManagerModules.nixvim
  ];
  home.username = "cdo";
  home.homeDirectory = "/home/cdo";

  home.stateVersion = "24.05"; # Please read the comment before changing.
}
