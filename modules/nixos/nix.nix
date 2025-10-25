{ config , inputs , ... }:
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
      !include ${config.sops.secrets.nix-github-token-file.path}
    '';
  };
  sops.secrets.nix-github-token-file = {
    sopsFile = "${inputs.cdo-secrets}/nix-github-token-file.sops";
    format = "binary";
    owner = "root";
    group = "nixbld";
    mode = "0440";
  };
}
