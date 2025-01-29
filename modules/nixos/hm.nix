{
  inputs,
  flake,
  moduleRoot,
  ...
}:
{
  home-manager = {
    backupFileExtension = "nix.bak";
    extraSpecialArgs = {
      inherit inputs;
      inherit moduleRoot;
    };
    #users.cdo = {
    #  home.stateVersion = "24.05";
    #};
    users.cdo = import (moduleRoot + "/home");
  };
}
