{
  self,
  inputs,
  lib,
  ...
}:
host:
{
  type,
  arch,
  modules,
  roles,
  args ? { },
  ...
}:
let
  inherit (inputs.nixpkgs.lib) nixosSystem;
  mkSystemRole = role: role;
  mkSystemRoles = map mkSystemRole;
in
nixosSystem {
  system = null;
  #  #modules = modules ++ mkSystemRoles roles.system;
  modules = modules ++ [
    {
      nixpkgs.hostPlatform = arch;
      environment.systemPackages = [
        inputs.nixpkgs.legacyPackages.${arch}.nil
      ];
    }
  ];
  extraArgs = {
    inherit inputs;
  } // args;
}
