{
  services.logind = {
    lidSwitch = "ignore";
    powerKey = "suspend";
  };
  services.upower.enable = true;
}
