{
  #args = {
  type = "laptop";
  hostname = "halley";
  arch = "x86_64-linux";
  os = "nixos";
  owner = "cdo";
  users = [ "cdo" ];
  graphical = false;
  packages.system = [ ];
  packages.home = [
    "base.nix"
    "desktop.nix"
    "development.nix"
    "terminal.nix"
    "sysadmin.nix"
    "games.nix"
  ];
  modules.nixos = [ ];
  modules.home = [
    ./home/hyprland.nix
    ./home/waybar.nix
    #inputs.stylix.homeModules.stylix
    "zed.nix"
    #"stylix.nix"
  ];
  #};
}
