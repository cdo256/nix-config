{ inputs, pkgs, system, nixvim, ... }:

let 
  nixvimLib = inputs.nixvim.lib.${inputs.system};
  nixvim' = inputs.nixvim.legacyPackages.${inputs.system};
  nixvimModule = nixvim'.makeNixvimWithModule {
    inherit pkgs;
    extraSpecialArgs = {
      inherit inputs;
      inherit system;
      inherit nixvimLib;
      inherit (inputs) nixvim';
    };
    module = {
      imports = [
      #  ./keys.nix
      #  ./opts.nix
      #  ./plugins/lualine.nix
      ];
    };
  };
in
{
  #programs.nixvim = nixvimModule;
  #packages.neovim = nixvimModule; #.overrideAttrs (oa: {
  #  meta = oa.meta // {
  #    description = "Neovim with NixVim configuration.";
  #  };
 # });
}
