{ config, flake, ... }:
let
  inherit (flake.lib) mkPackageList;
in
{
  config.environment = {
    systemPackages = mkPackageList {
      manifests = config.args.packages.system;
      inherit (config.args) arch;
    };
  };
}
