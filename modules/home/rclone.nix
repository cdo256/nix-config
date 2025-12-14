{ config, ... }:
{
  programs.rclone = {
    enable = true;
    remotes.g = {
      config = {
        type = "drive";
        scope = "drive";
        team_drive = ""; # no
      };
      secrets = {
        client_id = config.sops.secrets."google-drive/client_id";
        client_secret = config.sops.secrets."google-drive/client_secret";
      };
      bisyncs = {
        "obsidian" = {
          enable = true;
          mountPoint = "${config.home.homeDirectory}/obsidian";
          options = {
            umask = "077";
          };
        };
        "sync" = {
          enable = true;
          mountPoint = "${config.home.homeDirectory}/sync";
          options = {
            umask = "077";
          };
        };
        "secure" = {
          enable = true;
          mountPoint = "${config.home.homeDirectory}/.local/sync/secure";
          options = {
            umask = "077";
          };
        };
        "config" = {
          enable = true;
          mountPoint = "${config.home.homeDirectory}/.local/sync/config";
          options = {
            umask = "077";
          };
        };
      };
      mounts = {
        "archive" = {
          enable = true;
          mountPoint = "${config.home.homeDirectory}/archive";
          options = {
            umask = "077";
            vfs-cache-mode = "full";
            vfs-cache-max-age = "1h";
          };
        };
        "backup" = {
          enable = true;
          mountPoint = "${config.home.homeDirectory}/backup";
          options = {
            umask = "077";
            vfs-cache-mode = "full";
            vfs-cache-max-age = "1h";
          };
        };
      };
    };
  };
  sops.secrets = {
    "google-drive/client_id" = { };
    "google-drive/client_secret" = { };
  };
}
