{
  inputs,
  config,
  flake,
  pkgs,
  flake-pkgs,
  ...
}:
{
  home-manager = {
    backupCommand = "${pkgs.trash-cli}/bin/trash";
    extraSpecialArgs = {
      inherit
        inputs
        flake
        flake-pkgs
        ;
      inherit (config)
        args
        ;
    };
    users.${config.args.owner} = import (flake + "/users/${config.args.owner}");
  };
}
