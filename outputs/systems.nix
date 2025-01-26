{
  self,
  lib,
  ...
}@inputs:
let
  inherit (builtins) attrNames attrValues listToAttrs;
  inherit (lib.attrsets) mergeAttrsList;
  args = { inherit inputs lib; };
  nixosSystems = listToAttrs (
    map (system: {
      name = system;
      value = import ./x86_64-linux (args // { inherit system; });
    }) [ "x86_64-linux" ]
  );
in
{
  flake.nixosConfigurations = mergeAttrsList (
    map (it: it.nixosConfigurations or { }) (attrValues nixosSystems)
  );
}
