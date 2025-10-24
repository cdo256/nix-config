{
  services.netbird = {
    enable = true;
  };
  sops.secrets = {
    "coturn-password" = {
      owner = "root";
    };
  };
}
