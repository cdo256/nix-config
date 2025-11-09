{
  self,
  inputs,
  lib,
  self',
  ...
}:
let
  inherit (self.lib) mkHomeConfiguration;
  inherit (lib) mapAttrs mkOption;
  inherit (lib.types) lazyAttrsOf attrs;
  inherit (inputs.flake-parts.lib) mkSubmoduleOptions;
in
{
  options.flake.users = mkOption {
    type = lazyAttrsOf attrs;
    default = { };
    description = ''
      Input list of users.
    '';
  };
  config.flake.users.cdo = import ./cdo {
    inherit inputs;
    flake = self;
    args = import ./cdo/args.nix;
    config = { };
    flake' = self';
  };
  config.flake.homeConfigurations = mapAttrs mkHomeConfiguration self.users;
}
