{
  self,
  inputs,
  lib,
  withSystem,
  ...
}:
{
  modules,
  extraArgs ? { },
  basePath ? ../packages,
  system,
  ...
}:
(withSystem system (
  { pkgs, ... }:
  let
    inherit (inputs.nixpkgs.lib) concatMap;
    args = {
      inherit
        self
        inputs
        lib
        system
        pkgs
        ;
    } // extraArgs;
  in
  concatMap (module: import (basePath + module) args) modules
))
