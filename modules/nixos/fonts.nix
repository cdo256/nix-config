{
  config,
  pkgs,
  lib,
  ...
}:
{
  fonts = {
    enableDefaultPackages = true;
    packages = [
      pkgs.noto-fonts
      pkgs.noto-fonts-emoji
    ];
    fontconfig.defaultFonts = {
      emoji = [ "Noto Color Emoji" ];
    };
  };
  #programs.kitty = {
  #  enable = true;
  #  extraConfig = ''
  #    symbol_map U+2600-U+26FF Noto Color
  #  '';
  #};
}
