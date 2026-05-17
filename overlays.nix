{ inputs, ... }:
{
  flake.overlays = {
    hyprland = inputs.hyprland.overlays.default;
    mesa = final: prev: rec {
      mesa = inputs.nixpkgs-24-11.legacyPackages.${final.system}.mesa;
    };
    nh = inputs.nh.overlays.default;
    zed-extensions = inputs.zed-extensions.overlays.default;
  };
}
