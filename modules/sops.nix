{
  config,
  pkgs,
  lib,
  ...
}:

{
  sops = {
    defaultSopsFile = ../secrets/secrets.yaml;
    defaultSopsFormat = "yaml";
    age.keyFile = "/home/cdo/.config/sops/age/keys.txt";
    secrets = {
      "restic/halley/url" = { };
      "restic/halley/key" = { };
      "restic/peter/url" = { };
      "restic/peter/key" = { };
      "restic/rhiannon/url" = { };
      "restic/rhiannon/key" = { };
    };
  };
}
