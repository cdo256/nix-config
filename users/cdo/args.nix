{
  #args = {
  username = "cdo";
  type = "laptop";
  hostname = "halley";
  arch = "x86_64-linux";
  os = "nixos";
  owner = "cdo";
  users = [ "cdo" ];
  graphical = false;
  manifests = [
    "base.nix"
    "desktop.nix"
    "development.nix"
    "terminal.nix"
    "sysadmin.nix"
    "games.nix"
  ];
  modules = [ ];
  args = { };
}
