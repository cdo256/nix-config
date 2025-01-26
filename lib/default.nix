{ self, lib, ... }:
let
  cdolib = {
    mkNixosSystem = import ./mkNixosSystem.nix;
  };
in
{
  flake.lib = cdolib;
  perSystem._module.args.lib = cdolib;
}
