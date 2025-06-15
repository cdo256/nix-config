{ inputs, config, ... }:
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
    sopsFile = "${inputs.cdo-secrets}/remote-build-key.sops";
    format = "binary";
    owner = "root";
    group = "users";
    mode = "0440";
  };
}
