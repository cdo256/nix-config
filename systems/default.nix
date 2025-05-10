{
  self,
  inputs,
  ...
}:
let
  inherit (self.lib) mkNixosSystem;
  inherit (inputs.nixpkgs.lib) mapAttrs mkOption;
  inherit (inputs.nixpkgs.lib.types) attrs lazyAttrsOf;
  inherit (inputs.flake-parts.lib) mkSubmoduleOptions;
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
  options.flake.systems = mkOption {
    type = lazyAttrsOf system;
    default = { };
    description = ''
      Input list of systems;
    '';
  };
  config.flake.nixosConfigurations = mapAttrs mkNixosSystem self.systems;
}
