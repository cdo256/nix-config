{
  inputs,
  pkgs,
  args,
  ...
}:
let
  root = args.repoRoot + "/modules/home";
in
{
  imports = [
    ./vars.nix
    (root + "/base.nix")
    (root + "/fs.nix")
    (root + "/hyprland.nix")
    (root + "/hyprpanel.nix")
    (root + "/packages.nix")
    (root + "/dolphin.nix")
  ];
}
