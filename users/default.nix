{
  self,
  inputs,
  lib,
  ...
}:
let
  inherit (self.lib) mkHomeConfiguration types;
  inherit (lib) mapAttrs mkOption;
  inherit (inputs.flake-parts.lib) mkSubmoduleOptions;
in
{
  imports = [
    #./cdo
  ];
  options.flake = mkSubmoduleOptions {
    users = mkOption {
      type = types.lazyAttrsOf types.system;
      default = { };
      description = ''
        Input list of users.
      '';
    };
  };
  config.flake.homeConfigurations = mapAttrs mkHomeConfiguration self.users;
}
