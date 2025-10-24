{
  services.netbird.server = {
    enable = true; # Must be enabled only on servers.
    domain = "netbird.mutix.org";
    enableNginx = true;
    coturn = {
      enable = true;
      domain = "coturn.mutix.org";
      passwordFile = "/run/secrets/coturn-password";
    };
    management = {
      enable = true;
      enableNginx = true;
      domain = "netbird.mutix.org";
      settings = {
        Signal.URI = "signal.mutix.org:443";
        DataStoreEncryptionKey._secret = "/run/secrets/netbird-datastore-key";
      };
    };
    signal = {
      enable = true;
      enableNginx = true;
      domain = "signal.mutix.org";
    };

    dashboard = {
      enable = true;
      enableNginx = true;
      domain = "netbird.mutix.org";
      settings = {
        AUTH_AUTHORITY = "https://auth.mutix.org";
        AUTH_CLIENT_ID = "netbird";
        AUTH_AUDIENCE = "netbird";
        AUTH_SUPPORTED_SCOPES = "openid email profile offline_access";
        AUTH_REDIRECT_URI = "/auth";
        AUTH_SILENT_REDIRECT_URI = "/silent-auth";
      };
    };
  };

  sops.secrets = {
    "coturn-password" = {
      owner = "root";
    };
    "netbird-datastore-key" = {
      owner = "root";
    };
  };
}
