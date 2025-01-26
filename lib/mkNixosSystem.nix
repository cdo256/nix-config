{
  self,
  inputs,
  lib,
  ...
}:
host:
{
  modules ? [ ],
  type,
  ...
}:
let
  inherit (inputs.nixpkgs.lib) nixosSystem;
in
nixosSystem { }
