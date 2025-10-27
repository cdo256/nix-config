{
  inputs,
  flake,
  args,
  ...
}:
let
  inherit (flake.lib) withDefaultPath;
  baseModules = [
    "chromium.nix"
    "sway.nix"
    "waybar.nix"
    "wofi.nix"
    inputs.zed-extensions.homeManagerModules.default
  ];
  modules = map (withDefaultPath "/modules/home") (args.modules.home ++ baseModules);
in
{
  imports = modules;
}
