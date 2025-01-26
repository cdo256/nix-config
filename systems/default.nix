{
  self,
  lib,
  config,
  ...
}@inputs:
let
  inherit (builtins) attrNames attrValues listToAttrs;
  inherit (self.lib) mkNixosSystem;
  inherit (lib) mapAttrs;
  inherit (lib.attrsets) mergeAttrsList;
  args = { inherit inputs lib config; };
in
{
  imports = [
    # ./halley
    ./vm2
  ];
  flake.nixosConfigurations = mapAttrs mkNixosSystem self.systems;
}
