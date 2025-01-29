{
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
in
{
  options.cdo = {
    arch = mkOption {
      type = types.string;
    };
    type = mkOption {
      # TODO: Should be from a list of strings.
      type = types.string;
    };
  };
  config = {
    system.stateVersion = "24.05";
    nixpkgs.hostPlatform = config.cdo.arch;
    environment.systemPackages = [
      inputs.nixpkgs.legacyPackages.${config.cdo.arch}.nil
    ];
  };
}
