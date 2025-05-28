{ config, lib, ... }:

let
  cfg = config.services.borgbase;
  inherit (config.networking) hostName;
in
{
  options = {
    services.borgbase = {
      enable = lib.mkEnableOption "Enable Restic backup";
      repository = lib.mkOption {
        type = lib.types.str;
      };
    };
  };
  config = lib.mkIf cfg.enable {
    sops.secrets = {
      "restic/${hostName}/url" = { };
      "restic/${hostName}/key" = { };
    };
    services.restic.backups.borgbase = {
      repositoryFile = config.sops.secrets."restic/${hostName}/url".path;
      initialize = true;
      passwordFile = config.sops.secrets."restic/${hostName}/key".path;
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
          ignoreFile = builtins.toFile "ignore" (lib.lists.foldl (a: b: a + "\n" + b) "" ignorePatterns);
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
