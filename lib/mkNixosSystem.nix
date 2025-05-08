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
  inherit (self.lib) withDefaultPath;
  nixosModules = map (withDefaultPath "/modules/nixos") modules.nixos;
in
nixosSystem {
  system = null;
  modules = nixosModules ++ [
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
        flake = self;
      };
    }
  ];
}
