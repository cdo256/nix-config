{
  flake,
  inputs,
  pkgs,
  args,
  ...
}:
let
  inherit (flake.lib) withDefaultPath;
  baseModules = [
    ./vars.nix
    ./mbsync.nix
    "base.nix"
    "fish.nix"
    "fs.nix"
    "git.nix"
    "hyprland.nix"
    "hyprpanel.nix"
    "packages.nix"
    "readline.nix"
    "sway.nix"
    "waybar.nix"
    "wofi.nix"
  ];
  modules = map (withDefaultPath "/modules/home") (args.modules.home ++ baseModules);
in
{
  imports = modules;
}
