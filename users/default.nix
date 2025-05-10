{
  self,
  inputs,
  lib,
  ...
}:
let
  inherit (self.lib) mkHomeConfiguration;
  inherit (lib) mapAttrs mkOption;
  inherit (lib.types) lazyAttrsOf attrs;
  inherit (inputs.flake-parts.lib) mkSubmoduleOptions;
in
{
  imports = [
    #./cdo
  ];
  options.flake.users = mkOption {
    type = lazyAttrsOf attrs; # user;
    default = { };
    description = ''
      Input list of users.
    '';
  };
  config.flake.homeConfigurations = mapAttrs mkHomeConfiguration self.users;
}
