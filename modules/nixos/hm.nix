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
      let
        root = config.args.repoRoot + "/modules/home";
      in
      import (root + "/${config.args.owner}");
  };
}
