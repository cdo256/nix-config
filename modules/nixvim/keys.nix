{ config, lib, nixvim, ... }:

{
    globals = {
      mapleader = " ";
      maplocalleader = " ";
    };
    keymaps = let
      normal = lib.mapAttrsToList
        (key: action: {
	  mode = "n";
	  inherit action key;
	})
	{
          "<C-s>" = ":w<CR>";
	};
      visual = lib.mapAttrsToList
        (key: action: {
	  mode = "n";
	  inherit action key;
	})
	{
          "<C-s>" = ":w<CR>";
	};
    in
      nixvim.helpers.keymaps.mkKeymaps
      {options.silent = true;}
      (normal ++ visual);
}
