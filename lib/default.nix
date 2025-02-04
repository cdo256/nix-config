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
    mkPackageList = import ./mkPackageList.nix args;
  };
  perSystem._module.args.lib = self.lib;
}
