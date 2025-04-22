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
        manifests = [
          "/base.nix"
          "/system.nix"
        ];
        inherit arch;
      };
    };
    services.printing.enable = true;
  };
}
