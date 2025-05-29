{
  flake,
  config,
  options,
  inputs,
  ...
}:
let
  inherit (inputs.nixpkgs.lib)
    mkOption
    types
    ;
  inherit (flake.lib.types)
    system
    ;
  relpathType = types.oneOf [
    types.str
    types.path
  ];
  moduleType = types.oneOf [
    types.str
    types.path
    types.attrs
  ];
in
{
  options.args = mkOption {
    type = system;
    description = "Description of a NixOS system";
  };
  config = {
    system.stateVersion = "24.05";
    nixpkgs.hostPlatform = config.args.arch;
    networking.hostName = config.args.hostname;
    environment.systemPackages = [
      inputs.nixpkgs.legacyPackages.${config.args.arch}.nil
    ];
  };
}
