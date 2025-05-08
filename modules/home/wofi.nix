{ flake, ... }:
{
  programs.wofi = {
    enable = true;
    settings = {
      location = "top-right";
      allow_markup = true;
      width = 800;
    };
    style = builtins.readFile (flake + "/files/wofi/style.css");
  };
}
