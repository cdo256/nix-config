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
  options.args = {
    arch = mkOption {
      type = types.string;
    };
    type = mkOption {
      # TODO: Should be from a list of strings.
      type = types.string;
    owner = mkOption {
      type = types.str;
      description = "String of username of person who owns this system.";
    };
  };
  config = {
    system.stateVersion = "24.05";
    nixpkgs.hostPlatform = config.args.arch;
    environment.systemPackages = [
      inputs.nixpkgs.legacyPackages.${config.args.arch}.nil
    ];
  };
}
