{ pkgs, ... }:
{
  users.users.cdo = {
    description = "Christina O'Donnell";
    initialPassword = "";
    shell = pkgs.fish;
  };
}
