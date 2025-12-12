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
      pkgs.noto-fonts-cjk-sans
      pkgs.noto-fonts-color-emoji
      pkgs.unifont
      pkgs.fira-code
      pkgs.julia-mono
    ];
    fontconfig = {
      defaultFonts = {
        serif = [
          "DejaVu Serif"
          "Noto Sans Symbols"
          "Unifont"
        ];
        sansSerif = [
          "DejaVu Sans"
          "Noto Sans Symbols"
          "Unifont"
        ];
        emoji = [
          "Noto Color Emoji"
          "Noto Sans Symbols"
          "Unifont"
        ];
        monospace = [
          "Fira Code"
          "Noto Sans Mono"
          "Noto Sans Symbols"
          "Unifont"
        ];
      };
    };
  };
}
