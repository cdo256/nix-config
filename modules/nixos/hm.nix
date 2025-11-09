{
  inputs,
  config,
  flake,
  flake',
  pkgs,
  ...
}:
{
  home-manager = {
    backupCommand = "${pkgs.trash-cli}/bin/trash";
    extraSpecialArgs = {
      inherit
        inputs
        flake
        flake'
        ;
      inherit (config)
        args
        ;
    };
    users.${config.args.owner} = import (flake + "/users/${config.args.owner}");
  };
}
