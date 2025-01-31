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
  owner,
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
      config.args = {
        inherit type;
        inherit arch;
        inherit owner;
      };
    }
  ];
  extraArgs = {
    inherit inputs;
  } // args;
}
