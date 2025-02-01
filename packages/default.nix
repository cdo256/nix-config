{
  self,
  inputs,
  ...
}:
{
  perSystem =
    { system, pkgs, ... }:
    {
      packages = {
        home-manager = inputs.home-manager.defaultPackage.x86_64-linux;
        nixvim = inputs.nixvim.packages.x86_64-linux.default;
        files = pkgs.callPackage ./files.nix { };
      };
    };
}
