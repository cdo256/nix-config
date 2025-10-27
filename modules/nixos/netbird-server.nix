{
  services.netbird.server = {
    enable = true;
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
      oidcConfigEndpoint = "https://auth.mutix.org/auth/realms/master/.well-known/openid-configuration";
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
      owner = "turnserver";
      group = "turnserver";
    };
    "netbird-datastore-key" = {
      owner = "root";
    };
  };

  networking.firewall = {
    allowedTCPPorts = [
      80
      443 # Dashbord
      # 33073 # Management API
      # 33080 # Management API
      # 10000 # Signal
      3478 # STUN/TURN
      3479 # STUN/TURN
      5349 # STUN/TURN
      # 8011 # management
      # 9090 # management
    ];
    allowedUDPPorts = [
      # 51820 # WireGuard
      3478 # STUN/TURN
      3479 # STUN/TURN
      5349 # STUN/TURN
    ];
    allowedUDPPortRanges = [
      {
        from = 49152;
        to = 65535;
      } # TURN relay
    ];
  };
  services.nginx.virtualHosts = {
    "netbird.mutix.org" = {
      forceSSL = true;
      enableACME = true;
      locations."/" = {
        proxyPass = "http://127.0.0.1:33080/";
        proxyWebsockets = true;
      };
      locations."/api" = {
        proxyPass = "http://127.0.0.1:33073/";
        proxyWebsockets = true;
      };
      locations."/management.ManagementService/" = {
        proxyPass = "http://127.0.0.1:33073/management.ManagementService/";
        proxyWebsockets = true;
      };
    };
    "signal.mutix.org" = {
      forceSSL = true;
      enableACME = true;
      locations."/" = {
        proxyPass = "http://127.0.0.1:10000/";
        proxyWebsockets = true;
      };
    };
  };
}
