{
  self,
  inputs,
  ...
}:
{
  perSystem =
    { system, ... }:
    {
      packages = {
        home-manager = inputs.home-manager.defaultPackage.x86_64-linux;
        nixvim = inputs.nixvim.packages.x86_64-linux.default;
        #files = files;
      };
    };
}
