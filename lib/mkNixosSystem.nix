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
  packages,
  hostname,
  graphical ? (type == "laptop" || type == "desktop"),
  args ? { },
  ...
}:
let
  inherit (inputs.nixpkgs.lib) nixosSystem;
in
nixosSystem {
  system = null;
  modules = modules.nixos ++ [
    {
      config.args = {
        inherit
          type
          arch
          owner
          hostname
          packages
          graphical
          modules
          ;
      };
      config._module.args = {
        inherit inputs;
      } // args;
    }
  ];
}
