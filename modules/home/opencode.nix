{
  flake,
  args,
  pkgs,
  ...
}:
let
  opencodeDirPlugin = flake.packages.${args.arch}."opencode-dir";
in
{
  home.packages = [ pkgs.opencode ];

  home.file.".config/opencode/node_modules/opencode-dir".source =
    "${opencodeDirPlugin}/lib/node_modules/opencode-dir";
}
