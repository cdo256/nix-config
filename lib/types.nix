{ inputs, ... }:
let
  inherit (inputs.nixpkgs.lib)
    mkOption
    types
    ;
  inherit (types)
    bool
    str
    path
    oneOf
    attrs
    listOf
    attrsOf
    submodule
    submoduleWith
    functionTo
    ;
in
rec {
  defaultPath = oneOf [
    str
    path
  ];
  moduleRef = oneOf [
    str
    path
    attrs
    (functionTo attrs)
  ];
  mkSubmoduleType = (attrs: submoduleWith { modules = [ attrs ]; });
  system = mkSubmoduleType {
    options = {
      arch = mkOption {
        type = str;
        description = "Architecture string eg x86_64-linux";
      };
      type = mkOption {
        # TODO: Should be from a list of strings.
        type = str;
        description = "Kind of system, eg. server, laptop, destop, vm.";
      };
      os = mkOption {
        type = str;
        description = "Name of the OS, e.g. nixos, debian.";
      };
      owner = mkOption {
        type = str;
        description = "String of username of person who owns this system.";
      };
      users = mkOption {
        type = listOf str;
        description = "String of username of person who owns this system.";
      };
      hostname = mkOption {
        type = str;
        description = "The name of the machine.";
      };
      graphical = mkOption {
        type = bool;
        #default = config.args.type == "laptop" || config.args.type == "desktop";
        description = "Does this machine have a graphical display output?";
      };
      packages = {
        home = mkOption {
          type = listOf defaultPath;
          default = [ ];
          description = "List of manifests packages to run on the owner's home-manager configuration.";
        };
        system = mkOption {
          type = listOf defaultPath;
          default = [ ];
          description = "List of system manifests to run on this system.";
        };
      };
      modules = {
        home = mkOption {
          type = listOf moduleRef;
          default = [ ];
          description = "List of home-manager modules.";
        };
        nixos = mkOption {
          type = listOf moduleRef;
          default = [ ];
          description = "List of nixos modules.";
        };
      };
    };
  };
}
