{
  flake,
  inputs,
  ...
}:

{
  sops = {
    defaultSopsFile = "${inputs.cdo-secrets}/secrets.yaml";
    defaultSopsFormat = "yaml";
    age.keyFile = "/etc/sops/age/keys.txt";
    secrets = {
      "cdo/git-credentials" = {
        owner = "cdo";
      };
      "cdo/mutix-password" = {
        owner = "cdo";
      };
    };
  };
}
