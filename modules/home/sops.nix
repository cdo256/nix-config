{
  inputs,
  config,
  ...
}:
{
  sops = {
    age.keyFile = "/etc/sops/age/keys.txt";
    defaultSopsFile = "${inputs.cdo-secrets}/secrets.yaml";
    defaultSopsFormat = "yaml";
  };
}
