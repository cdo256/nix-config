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
        home-manager = inputs.home-manager.packages.${system}.default;
        nixvim = inputs.nixvim.packages.${system}.default;
        files = pkgs.callPackage ./files.nix { };
        python-utils = pkgs.callPackage ./python-utils { };
        sc-im = pkgs.sc-im.overrideAttrs { xlsSupport = true; };
        just-agda = inputs.just-agda.packages.${system}.default;
      };
    };
}
