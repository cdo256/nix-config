{
  flake,
  config,
  inputs,
  ...
}:

{
  sops = {
    defaultSopsFile = "${inputs.secrets}/hosts/${config.networking.hostName}.yaml";
    defaultSopsFormat = "yaml";
    age.keyFile = "/etc/sops/age/keys.txt";
  };
}
