{
  inputs,
  args,
  flake,
  ...
}:
{
  home.packages = flake.lib.mkPackageList {
    modules = args.packages.home;
    system = args.arch;
  };
}
