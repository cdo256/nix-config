services.nginx = {
  enable = true;
  virtualHosts."octocurious.org" = {
    enableACME = true;
    root = "/var/www/octocurious";
    
    # Optional: Handle 404s by routing to 404.html for SPA-like behavior if necessary
    locations."/" = {
      tryFiles = "$uri $uri/ =404";
    };
  };
};
