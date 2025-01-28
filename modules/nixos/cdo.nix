{
  users.users.cdo = {
    uid = 1000;
    isNormalUser = true;
    description = "Christina O'Donnell";
    extraGroups = [
      "networkmanager"
      "wheel"
    ];
    initialPassword = "";
    packages = [
    ];
    shell = pkgs.fish;
  };

}
