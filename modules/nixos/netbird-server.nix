{
  services.netbird.server = {
    #enable = true; # Must be enabled only on servers.
    domain = "netbird.mutix.org";
    enableNginx = true;
    coturn = {
      enable = true;
      domain = "coturn.mutix.org";
      passwordFile = "/run/secrets/coturn-password";
    };
    # TODO
    #management = { };
  };
}
