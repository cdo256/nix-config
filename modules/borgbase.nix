{config, lib, ...}:

let
  cfg = config.services.borgbase;
in
{
  options = {
    services.borgbase = {
      enable = lib.mkEnableOption "Enable Restic backup";
      repository = lib.mkOption {
        type = lib.types.string;
      };
    };
  };
  config = lib.mkIf cfg.enable {
    services.restic.backups.borgbase = {
      repository = cfg.repository;
      initialize = true;
      passwordFile = "/var/restic/borgbase.pass";
      paths = [ "/home" "/var" ];
      extraBackupArgs = let
        ignorePatterns = [
          "/home/*/.local/share/trash"
          "/home/*/src"
          "/home/*/.local"
          ".cache"
          ".tmp"
          ".log"
          ".Trash"
        ];
        ignoreFile = builtins.toFile "ignore"
          (lib.lists.foldl (a: b: a + "\n" + b) "" ignorePatterns);
      in [
          "--exclude-file=${ignoreFile}"
          "-vv"
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