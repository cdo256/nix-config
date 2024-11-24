{ inputs, nix, config, lib, pkgs, nixpkgs, stdenv, nixvim, ... }:

{
  imports = [
  ];
  programs.nixvim = {
    specialArgs = {
      #inherit inputs;
      #inherit config;
      inherit nixvim;
    };
    imports = [
      ./opts.nix
      ./keys.nix
      ./plugins/lualine.nix
    ];
    enable = true;
  };
}
