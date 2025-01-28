{
  self,
  inputs,
  lib,
  withSystem,
  ...
}@args:
{
  flake.lib = {
    mkNixosSystem = import ./mkNixosSystem.nix args;
    mkPackageList = import ./mkPackageList.nix {
      inherit
        self
        inputs
        lib
        withSystem
        ;
    };
  };
  perSystem._module.args.lib = self.lib;
}
