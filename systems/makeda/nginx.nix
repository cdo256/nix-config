{
  services.nginx = {
    enable = true;
    virtualHosts."octocurious.com" = {
      enableACME = true;
      forceSSL = true;
      root = "/var/www/octocurious";
      
      locations."/" = {
        tryFiles = "$uri $uri/ =404";
      };
    };
  };
  security.acme = {
    acceptTerms = true;
    defaults.email = "christina@octocurious.com";
  };
  networking.firewall.allowedTCPPorts = [ 80 443 ];
}
