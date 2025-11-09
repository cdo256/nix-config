{
  self,
  inputs,
  withSystem,
  ...
}@inputs':
{
  modules,
  ...
}:
#{
#  username,
#  manifests,
#  graphical,
#  modules,
#  args ? { },
#  arch,
#  ...
#}:
let
  inherit (self.lib) withDefaultPath;
  inherit (mkHomeManagerConfiguration) mkHomeManagerConfiguration;
in
withSystem arch (
  { pkgs, self', ... }:
  { }
  #inputs.home-manager.lib.homeManagerConfiguration {
  #  #extraSpecialArgs = {
  #  #  inherit inputs args;
  #  #  flake = self;
  #  #  flake' = self';
  #  #};
  #  modules = map (withDefaultPath "/modules/home") modules ++ [
  #    {
  #      config.home = {
  #        stateVersion = "24.05"; # Please read the comment before changing.
  #        username = "cdo-test";
  #        homeDirectory = "/home/cdo";
  #      };
  #    }
  #  ];
  #  inherit pkgs;
  #}
)
