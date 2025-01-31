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
  hostname,
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
        inherit
          type
          arch
          owner
          hostname
          ;
      };
    }
  ];
  extraArgs = {
    inherit inputs;
  } // args;
}
