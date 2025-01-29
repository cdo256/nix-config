{
  self,
  inputs,
  lib,
  ...
}:
host:
{
  type,
  arch,
  modules,
  args ? { },
  ...
}:
let
  inherit (inputs.nixpkgs.lib) nixosSystem;
in
nixosSystem {
  system = null;
  modules = modules ++ [
    {
      config.cdo = {
        inherit type;
        inherit arch;
      };
    }
  ];
  extraArgs = {
    inherit inputs;
  } // args;
}
