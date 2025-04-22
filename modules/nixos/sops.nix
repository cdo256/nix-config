{
  flake,
  config,
  pkgs,
  lib,
  ...
}:

{
  sops = {
    defaultSopsFile = flake.root + "/secrets/secrets.yaml";
    defaultSopsFormat = "yaml";
    age.keyFile = "/etc/sops/age/keys.txt";
    secrets = {
      "restic/halley/url" = { };
      "restic/halley/key" = { };
      "restic/peter/url" = { };
      "restic/peter/key" = { };
      "restic/makeda/url" = { };
      "restic/makeda/key" = { };
      "restic/rhiannon/url" = { };
      "restic/rhiannon/key" = { };
      "cdo/git-credentials" = {
        owner = "cdo";
      };
    };
  };
}
