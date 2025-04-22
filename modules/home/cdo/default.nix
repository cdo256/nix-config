{
  flake,
  inputs,
  pkgs,
  args,
  ...
}:
let
  root = flake.root + "/modules/home";
in
{
  imports = [
    ./vars.nix
    (root + "/base.nix")
    (root + "/fish.nix")
    (root + "/fs.nix")
    (root + "/hyprland.nix")
    (root + "/hyprpanel.nix")
    (root + "/packages.nix")
    (root + "/sway.nix")
  ] ++ args.modules.home;
}
