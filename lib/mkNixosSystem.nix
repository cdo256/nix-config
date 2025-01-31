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
  graphical,
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
          graphical
          ;
      };
    }
  ];
  extraArgs = {
    inherit inputs;
  } // args;
}
