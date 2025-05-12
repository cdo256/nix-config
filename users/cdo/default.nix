{
  flake,
  args,
  ...
}:
let
  inherit (flake.lib) withDefaultPath;
  baseModules = [
    ./vars.nix
    ./email.nix
    "base.nix"
    "direnv.nix"
    "fish.nix"
    "fs.nix"
    "git.nix"
    "hyprland.nix"
    "hyprpanel.nix"
    "jujutsu.nix"
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
