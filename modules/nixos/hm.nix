{ inputs, moduleRoot, ... }:
{
  home-manager = {
    backupFileExtension = "nix.bak";
    extraSpecialArgs = {
      inherit inputs;
      #inherit files;
      extraImports = [ ];
    };
    #users.cdo = {
    #  home.stateVersion = "24.05";
    #};
    users.cdo = import (moduleRoot + "/home/client.nix");
  };
}
