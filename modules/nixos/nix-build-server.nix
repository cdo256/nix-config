{
  inputs,
  config,
  lib,
  ...
}:

let
  inherit (inputs) cdo-secrets;
in
{
  sops.secrets = {
    "remote-build-key" = {
      sopsFile = "${cdo-secrets}/remote-buidl-key.sops";
    };
  };
  users.users.remotebuild = {
    isNormalUser = true;
    createHome = false;
    group = "remotebuild";
    openssh.authorizedKeys = [ config.sops.secrets.remote-build-key.path ];
  };
  users.groups.remotebuild = { };

  nix.settings.trusted-users = [ "remotebuild" ];
}
