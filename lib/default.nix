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
    mkHomeConfiguration = import ./mkHomeConfiguration.nix args;
    mkPackageList = import ./mkPackageList.nix args;
    getRelativePath = import ./getRelativePath.nix args;
    withDefaultPath = import ./withDefaultPath.nix args;
    types = import ./types.nix args;
  };
  perSystem._module.args.lib = self.lib;
}
