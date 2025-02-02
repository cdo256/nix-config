{
  self,
  inputs,
  config,
  lib,
  withSystem,
  ...
}:
{
  modules,
  extraArgs ? { },
  basePath ? (config.flake.repoRoot + "/manifests"),
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
  concatMap (
    module:
    if lib.isPath module then # .
      import module args
    else
      import (basePath + module) args
  ) modules
))
