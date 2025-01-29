{ moduleRoot, ... }:
{
  imports = [
    (moduleRoot + "/home/client.nix")
    (moduleRoot + "/home/fs.nix")
    #(moduleRoot + "/home/hyprland.nix")
    #(moduleRoot + "/home/hyprpanel.nix")
    #(moduleRoot + "/home/fonts.nix")
    #(moduleRoot + "/home/fish.nix")
  ];
}
