{
  inputs,
  flake,
  args,
  ...
}:
let
  inherit (flake.lib) withDefaultPath;
  baseModules = [
    ./vars.nix
    ./email.nix
    "vars.nix"
    "base.nix"
    "chromium.nix"
    "direnv.nix"
    "fish.nix"
    "fs.nix"
    "git.nix"
    "jujutsu.nix"
    "packages.nix"
    "readline.nix"
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
