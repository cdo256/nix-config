{
  self,
  inputs,
  lib,
  options,
  config,
  ...
}:
let
  inherit (builtins) attrNames attrValues listToAttrs;
  inherit (self.lib) mkNixosSystem;
  inherit (lib) mapAttrs mkOption;
  inherit (lib.attrsets) mergeAttrsList;
  inherit (lib.types) lazyAttrsOf attrs;
  inherit (inputs.flake-parts.lib) mkSubmoduleOptions;
  args = { inherit inputs lib config; };
in
{
  imports = [
    ./halley
    ./vm2
    ./vm3
  ];
  options.flake = mkSubmoduleOptions {
    systems = mkOption {
      type = lazyAttrsOf attrs;
      default = { };
      description = ''
        Input list of systems;
      '';
    };
  };
  config.flake.nixosConfigurations = mapAttrs mkNixosSystem self.systems;
}
