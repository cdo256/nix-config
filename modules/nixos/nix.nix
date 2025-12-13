{ config, inputs, ... }:
{
  nix = {
    settings = {
      experimental-features = [
        "nix-command"
        "flakes"
      ];
      warn-dirty = false;
    };
    extraOptions = ''
      !include ${config.sops.secrets.nixos-github-token.path}
    '';
  };
  sops.secrets.nixos-github-token = {
    sopsFile = "${inputs.secrets}/hosts/${config.networking.hostName}.yaml";
    owner = "root";
    group = "users";
    mode = "0440";
    restartUnits = [ "nix-daemon.service" ];
  };
}
