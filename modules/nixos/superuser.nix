{ config, ... }:
{
  users.users.${config.args.owner} = {
    uid = 1000;
    isNormalUser = true;
    extraGroups = [
      "networkmanager"
      "wheel"
      "input"
      "video"
      "audio"
      "docker"
    ];
    openssh.authorizedKeys.keyFiles = config.devices.commonKeys;
  };
  nix.settings.trusted-users = [ config.args.owner ];
}
