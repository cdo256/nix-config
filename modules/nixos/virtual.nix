{
  inputs,
  config,
  options,
  ...
}:
let
  inherit (inputs.nixpkgs.lib) mkOverride;
in
{
  config.virtualisation.vmVariant = {
    virtualisation = {
      memorySize = 2048;
      cores = 2;
      graphics = config.args.graphical;
    };
  };
}
