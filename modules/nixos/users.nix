{ inputs, config, ... }:
let
  inherit (inputs.nixpkgs.lib) genAttrs;
  inherit (config.args) users;
in
{
  config.users.users = genAttrs users (
    user:
    let
      home = config.home-manager.users.${user};
    in
    {
      description = home.home.fullName;
      initialPassword = "";
      shell = home.home.defaults.shellPackage;
    }
  );
}
