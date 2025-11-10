{
  inputs,
  config,
  ...
}:
{
  sops = {
    age.keyFile = "${config.home.homeDirectory}/.config/sops/age/user-keys.txt";
    defaultSopsFormat = "yaml";
  };
}
