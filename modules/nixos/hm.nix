{
  inputs,
  config,
  flake,
  ...
}:
{
  home-manager = {
    backupFileExtension = "nix.bak";
    extraSpecialArgs = {
      inherit
        inputs
        flake
        ;
      inherit (config)
        args
        ;
    };
    users.${config.args.owner} =
      import (flake + "/users/${config.args.owner}");
  };
}
