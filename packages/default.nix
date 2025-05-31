{
  inputs,
  ...
}:
{
  perSystem =
    { pkgs, ... }:
    {
      packages = {
        home-manager = inputs.home-manager.packages.x86_64-linux.default;
        nixvim = inputs.nixvim.packages.x86_64-linux.default;
        files = pkgs.callPackage ./files.nix { };
        python-utils = pkgs.callPackage ./python-utils { };
        sc-im = pkgs.sc-im.overrideAttrs { xlsSupport = true; };
        chromium-id-generator = pkgs.callPackage ./chromiumIdGenerator.nix { };
      };
    };
}
