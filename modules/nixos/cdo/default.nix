{ pkgs, ... }:
{
  imports = [
    ./syncnet.nix
  ];
  config.users.users.cdo = {
    description = "Christina O'Donnell";
    initialPassword = "";
    shell = pkgs.fish;
  };
  config.programs.fish.enable = true;
}
