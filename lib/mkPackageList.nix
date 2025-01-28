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
let
  args = {
    inherit self inputs lib;
  } // extraArgs;
in
map (
  module:
  let
    package = import (basePath + module) args;
  in
  withSystem system ({ pkgs, ... }: pkgs.callPackage package)
) modules
