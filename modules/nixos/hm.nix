{
  inputs,
  config,
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
      inherit (config) args;
    };
    #users.cdo = {
    #  home.stateVersion = "24.05";
    #};
    users.${config.args.owner} = import (moduleRoot + "/home");
  };
}
