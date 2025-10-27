{ args, ... }:
{
  imports =
    if args.graphical then
      [
        ./base.nix
        ./graphical.nix
      ]
    else
      [ ./base.nix ];
}
