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
    "direnv.nix"
    "fish.nix"
    "fs.nix"
    "git.nix"
    "jujutsu.nix"
    "packages.nix"
    "readline.nix"
  ]
  ++ (
    if args.graphical then
      [
        "chromium.nix"
        "sway.nix"
        "waybar.nix"
        "wofi.nix"
        inputs.zed-extensions.homeManagerModules.default
        inputs.plasma-manager.homeManagerModules.plasma-manager
        "plasma.nix"
      ]
    else
      [ ]
  );
  modules = map (withDefaultPath "/modules/home") (args.modules.home ++ baseModules);
in
{
  imports = modules;
}
