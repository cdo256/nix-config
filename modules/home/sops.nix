{
  inputs,
  config,
  osConfig,
  ...
}:
{
  sops = {
    defaultSopsFile = "${inputs.secrets}/hosts/${osConfig.networking.hostName}.yaml";
    age.keyFile = "${config.home.homeDirectory}/.config/sops/age/keys.txt";
    defaultSopsFormat = "yaml";
  };
}
