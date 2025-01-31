{ config, ... }:
{
  users.users.${config.args.owner} = {
    uid = 1000;
    isNormalUser = true;
    extraGroups = [
      "networkmanager"
      "wheel"
    ];
  };
}
