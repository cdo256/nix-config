{
  flake,
  ...
}:
let
  arch = "x86_64-linux";
in
{
  config = {
    args = {
      inherit arch;
      type = "vm";
      owner = "cdo";
    };
    environment = {
      systemPackages = flake.lib.mkPackageList {
        modules = [
          "/base.nix"
          "/system.nix"
        ];
        system = arch;
      };
    };
    services.printing.enable = true;
  };
}
