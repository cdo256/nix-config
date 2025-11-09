{
  self,
  inputs,
  withSystem,
  ...
}@inputs':
{
  username,
  manifests,
  graphical,
  modules ? [ ],
  args ? { },
  arch,
  ...
}:
let
  inherit (self.lib) withDefaultPath;
in
withSystem arch (
  { pkgs, self', ... }:
  {
    extraSpecialArgs = {
      inherit inputs args;
      flake = self;
      flake' = self';
    };
    modules = map (withDefaultPath "/modules/home") modules;
    inherit pkgs;
  }
)
