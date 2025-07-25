{ inputs, ... }:
{
  flake.overlays = {
    hyprland = inputs.hyprland.overlays.default;
    nixvim = final: prev: rec {
      nixvim = inputs.nixvim.packages.${final.system}.default;
      nvim = nixvim;
    };
    nh = inputs.nh.overlays.default;
    zed-extensions = inputs.zed-extensions.overlays.default;
  };
}
