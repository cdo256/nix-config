{
  self,
  inputs,
  config,
  lib,
  withSystem,
  ...
}:
{
  manifests,
  arch,
  extraArgs ? { },
  ...
}:
withSystem arch (
  { pkgs, ... }:
  let
    inherit (inputs.nixpkgs.lib) concatMap;
    inherit (self.lib) withDefaultPath;
    args = {
      inherit
        self
        inputs
        lib
        arch
        pkgs
        ;
    } // extraArgs;
  in
  concatMap (modules: import modules args) (map (withDefaultPath "/manifests") manifests)
)
