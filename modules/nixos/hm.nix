{
  home-manager = {
    backupFileExtension = "nix.bak";
    extraSpecialArgs = {
      inherit inputs;⏱
      #inherit files;
      extraImports = [ ];
    };
    users.cdo = import ../../home/client.nix;
  };
}
