{ self, inputs, ... }:
let
  inherit (inputs.nixpkgs.lib) foldl' removeAttrs;
  mergeAttrs = foldl' (a: b: a // removeAttrs b [ "default" ]) { };
in
{
  systems = [
    "x86_64-linux"
  ];
  perSystem =
    { system, ... }:
    {
      _module.args = rec {
        nixpkgs-pkgs = import inputs.nixpkgs {
          inherit system;
          config = {
            allowUnfree = true;
            allowUnsupportedSystem = true;
          };
        };
        hyprland-pkgs = inputs.hyprland.inputs.nixpkgs.legacyPackages.${system};
        nixvim-pkgs = inputs.nixvim.packages.${system};
        nh-pkgs = inputs.nh.packages.${system};
        home-manager-pkgs = inputs.home-manager.packages.${system};
        pkgs = mergeAttrs [
          home-manager-pkgs
          nh-pkgs
          nixvim-pkgs
          hyprland-pkgs
          nixpkgs-pkgs
        ];
      };
    };
}
