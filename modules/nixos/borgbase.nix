{ inputs, config, ... }:

let
  cfg = config.services.borgbase;
  inherit (inputs.nixpkgs.lib) mkEnableOption mkOption mkIf;
  inherit (inputs.nixpkgs.lib.types) str;
  inherit (inputs.nixpgks.lib.lists) foldl;
in
{
  options = {
    services.borgbase = {
      enable = mkEnableOption "Enable Restic backup";
      repository = mkOption {
        type = str;
      };
    };
  };
  config = mkIf cfg.enable {
    services.restic.backups.borgbase = {
      repositoryFile = config.sops.secrets."restic/${config.networking.hostName}/url".path;
      initialize = true;
      passwordFile = config.sops.secrets."restic/${config.networking.hostName}/key".path;
      paths = [
        "/home"
        "/root"
        "/var"
        "/usr"
        "/boot"
        "/srv"
        "/etc"
        "/nix"
        "/opt"
      ];
      extraBackupArgs =
        let
          ignorePatterns = [ ];
          ignoreFile = builtins.toFile "ignore" (foldl (a: b: a + "\n" + b) "" ignorePatterns);
        in
        [
          "--exclude-file=${ignoreFile}"
        ];
      pruneOpts = [
        "--keep-daily 7"
        "--keep-weekly 4"
        "--keep-monthly 3"
        "--keep-yearly 1"
      ];
    };
  };
}
