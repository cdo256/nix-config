{ inputs, ... }:
{
  flake.overlays = {
    hyprland = inputs.hyprland.overlays.default;
    nixvim = final: prev: rec {
      nixvim = inputs.nixvim.packages.${final.system}.default;
      nvim = nixvim;
    };
    mesa = final: prev: rec {
      mesa = inputs.nixpkgs-24-11.legacyPackages.${final.system}.mesa;
    };
    nh = inputs.nh.overlays.default;
    zed-extensions = inputs.zed-extensions.overlays.default;
  };
}
