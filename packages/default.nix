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
        home-manager = inputs.home-manager.packages.x86_64-linux.default;
        nixvim = inputs.nixvim.packages.x86_64-linux.default;
        files = pkgs.callPackage ./files.nix { };
        sc-im = pkgs.sc-im.overrideAttrs { xlsSupport = true; };
      };
    };
}
