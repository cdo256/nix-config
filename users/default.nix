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
  cdo =
    let
      args = import ./cdo/args.nix;
    in
    import ./cdo {
      inherit inputs;
      flake = self;
      args = import ./cdo/args.nix;
      inherit (args)
        arch
        graphical
        username
        manifests
        ;
      config = { };
      flake' = self';
    };

in
{
  options.flake.users = mkOption {
    type = lazyAttrsOf attrs;
    default = { };
    description = ''
      Input list of users.
    '';
  };
  config.flake.users.cdo =
    let
      args = import ./cdo/args.nix;
    in
    import ./cdo {
      inherit inputs;
      flake = self;
      args = import ./cdo/args.nix;
      inherit (args)
        arch
        graphical
        username
        manifests
        ;
      config = { };
      flake' = self';
    };
  #config.flake.homeConfigurations = mapAttrs mkHomeConfiguration self.users;
  config.flake.homeConfigurations.cdo = mkHomeConfiguration (import ./cdo/args.nix);
}
