{
  self,
  inputs,
  lib,
  ...
}:
let
  inherit (self.lib) mkNixosSystem;
  inherit (lib) mapAttrs mkOption;
  inherit (inputs.flake-parts.lib) mkSubmoduleOptions;
  inherit (lib.types) attrs lazyAttrsOf;
  inherit (self.lib.types) system;
in
{
  imports = [
    ./halley
    ./peter
    ./makeda
    ./vm2
    ./vm3
  ];
  options.flake = mkSubmoduleOptions {
    systems = mkOption {
      type = lazyAttrsOf system;
      default = { };
      description = ''
        Input list of systems;
      '';
    };
  };
  config.flake.nixosConfigurations = mapAttrs mkNixosSystem self.systems;
}
