{
  self,
  inputs,
  lib,
  nixpkgs,
  ...
}:
let
  cdolib = {
    mkNixosSystem = import ./mkNixosSystem.nix {
      inherit
        self
        inputs
        lib
        nixpkgs
        ;
    };
  };
in
{
  flake.lib = cdolib;
  perSystem._module.args.lib = cdolib;
}
