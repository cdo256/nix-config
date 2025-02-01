{ config, flake, ... }:
{
  config.environment = {
    systemPackages = flake.lib.mkPackageList {
      modules = [
        "/base.nix"
        "/system.nix"
      ];
      system = config.args.arch;
    };
  };
}
