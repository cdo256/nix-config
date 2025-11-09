{
  self,
  inputs,
  withSystem,
  ...
}:
host:
{
  type,
  arch,
  modules,
  owner,
  users,
  packages,
  hostname,
  graphical ? (type == "laptop" || type == "desktop"),
  args ? { },
  ...
}:
let
  inherit (inputs.nixpkgs.lib) nixosSystem;
  inherit (self.lib) withDefaultPath;
  nixosModules = map (withDefaultPath "/modules/nixos") modules.nixos ++ [ (self + "/devices.nix") ];
in
withSystem arch (
  { inputs', self', ... }:
  nixosSystem {
    system = null;
    modules = nixosModules ++ [
      {
        config.args = {
          inherit
            type
            arch
            owner
            users
            hostname
            packages
            graphical
            modules
            ;
        };
        config._module.args = {
          inherit inputs;
          flake = self;
          flake' = self';
        }
        // inputs';
      }
    ];
  }
)
