{
  self,
  inputs,
  ...
}:
let
  inherit (self.lib) mkHomeConfiguration;
  inherit (inputs.nixpkgs.lib) mapAttrs mkOption;
  inherit (inputs.nixpkgs.lib.types) lazyAttrsOf attrs;
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
