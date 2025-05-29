{
  inputs,
  ...
}:

{
  sops = {
    defaultSopsFile = "${inputs.example-secrets}/secrets.yaml";
    defaultSopsFormat = "yaml";
    age.keyFile = "/etc/sops/age/keys.txt";
    secrets = {
      "example/example-secret" = {
        owner = "example";
      };
    };
  };
}
