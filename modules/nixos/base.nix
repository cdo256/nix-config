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
      type = types.str;
      description = "Architecture string eg x86_64-linux";
    };
    type = mkOption {
      # TODO: Should be from a list of strings.
      type = types.str;
      description = "server, laptop, destop, vm, etc.";
    };
    owner = mkOption {
      type = types.str;
      description = "String of username of person who owns this system.";
    };
    hostname = mkOption {
      type = types.str;
      description = "The name of the machine.";
    };
    graphical = mkOption {
      type = types.bool;
      default = config.args.type == "laptop" || config.args.type == "desktop";
      description = "Does this machine have a graphical display output.";
    };
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
