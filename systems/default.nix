{
  self,
  lib,
  config,
  ...
}@inputs:
let
  inherit (builtins) attrNames attrValues listToAttrs;
  inherit (lib.attrsets) mergeAttrsList;
  args = { inherit inputs lib config; };
in
{
  flake.nixosConfigurations = {
    halley = import ./halley;
    vm2 = import ./vm2;
  };
}
