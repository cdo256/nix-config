{ inputs, nix, config, lib, pkgs, nixpkgs, stdenv, nixvim, ... }:

{
  imports = [
    ./opts.nix
    ./keys.nix
  ];
  programs.nixvim = {
    enable = false;
  };
}
