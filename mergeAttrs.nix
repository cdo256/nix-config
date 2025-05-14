{
  self,
  inputs,
  ...
}:
exclude: attrsList:
let
  inherit (inputs.nixpkgs.lib) foldl' removeAttrs;
in
foldl' (a: b: a // removeAttrs b [ "default" ]) { } attrsList
