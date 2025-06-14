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
      _module.args = {
        pkgs = import inputs.nixpkgs {
          inherit system;
          config = {
            allowUnfree = true;
            allowUnsupportedSystem = true;
          };
          overlays = with self.overlays; [
            nh
            nixvim
          ];
        };
      };
    };
}
