{
  inputs,
  config,
  osConfig,
  ...
}:
{
  programs.ssh = {
    enable = true;
    matchBlocks = {
      "remotebuild" = {
        hostName = "makeda";
        user = "remotebuild";
        identityFile = config.sops.secrets.remote-build-key.path;
        forwardAgent = "yes";
      };
    };
  };
  sops.secrets.remote-build-key = {
    sopsFile = "${inputs.secrets}/hosts/${osConfig.networking.hostName}/remote-build-key.sops";
    format = "binary";
    mode = "0400";
  };
}
