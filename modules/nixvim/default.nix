{ inputs, pkgs, system, nixvim, ... }:

let 
  nixvimLib = nixvim.lib.${system};
  nixvim' = nixvim.legacyPackages.${system};
  nixvimModule = nixvim'.makeNixvimWithModule {
    #inherit pkgs;
    extraSpecialArgs = {
      #inherit inputs;
      #inherit nixvimLib;
      #inherit nixvim';
    };
    module = {

    };
  };
in
{
  #programs.nixvim = {
  #  #specialArgs = {
  #    #inherit inputs;
  #    #inherit config;
  #  #  inherit nixvim;
  #  #};
  #  imports = [
  #  #  ./opts.nix
  #  #  ./keys.nix
  #  #  ./plugins/lualine.nix
  #  ];
  #  enable = true;
  #};
}
