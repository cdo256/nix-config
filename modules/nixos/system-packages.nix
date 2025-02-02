{ config, flake, ... }:
{
  config.environment = {
    systemPackages = flake.lib.mkPackageList {
      modules = config.args.packages.system;
      system = config.args.arch;
    };
  };
}
