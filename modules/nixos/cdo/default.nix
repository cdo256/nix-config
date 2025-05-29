{ pkgs, config, ... }:
{
  imports = [
    ./syncnet.nix
    ./secrets.nix
  ];
  config.users.users.cdo = {
    description = config.home-manager.users.cdo.home.fullName;
    initialPassword = "";
    shell = pkgs.fish;
  };
  config.programs.fish.enable = true;
}
