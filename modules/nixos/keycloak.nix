{
  services.keycloak = {
    enable = true;
    #initialAdminPassword = builtins.readFile "/run/secrets/keycloak-admin-password";
    database = {
      type = "postgresql";
      createLocally = true;
      username = "keycloak";
      passwordFile = "/run/secrets/keycloak-db-password";
    };
    #realmFiles = [ /path/to/realm-export.json ]; # optional provisioning of realms
    settings = {
      hostname = "auth.mutix.org";
      http-relative-path = "/auth";
      http-port = 38080;
      http-enabled = true;
      #proxy = "passthrough";
      #proxy-headers = "xforwarded";
      hostname-strict-https = true;
    };
  };
  sops.secrets = {
    "keycloak-admin-password" = {
      owner = "root";
    };
    "keycloak-db-password" = {
      owner = "root";
    };
  };
  networking.firewall = {
    allowedTCPPorts = [ 33080 ];
  };
  services.nginx.virtualHosts."auth.mutix.org" = {
    forceSSL = true;
    enableACME = true;
    locations."/auth" = {
      proxyPass = "http://127.0.0.1:38080/auth/";
      proxyWebsockets = true;
    };
  };
}
