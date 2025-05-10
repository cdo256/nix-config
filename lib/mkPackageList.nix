{
  self,
  inputs,
  config,
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
        arch
        pkgs
        ;
    } // extraArgs;
  in
  concatMap (modules: import modules args) (map (withDefaultPath "/manifests") manifests)
)
