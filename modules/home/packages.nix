{
  inputs,
  args,
  flake,
  ...
}:
{
  home.packages = flake.lib.mkPackageList {
    manifests = args.packages.home;
    inherit (args) arch;
  };
}
