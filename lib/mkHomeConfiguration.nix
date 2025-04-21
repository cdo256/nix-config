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
  inherit (self.lib) withDefaultPath mkPackageList;
  modules' = modules ++ [
    {
      home.packages = mkPackageList { inherit manifests arch; };
    }
  ];
in
withSystem arch (
  { pkgs, ... }:
  {
    extraSpecialArgs = {
      inherit inputs args;
      flake = self;
    };
    modules = map (withDefaultPath "/modules/home") modules';
    inherit pkgs;
  }
)
