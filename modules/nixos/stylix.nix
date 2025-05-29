{ inputs, ... }:
{
  stylix = {
    enable = true;
    polarity = "dark";
    base16Scheme = {
      base00 = "#000000";
      base01 = "#0f0d38";
      base02 = "#c5020e";
      base03 = "#16e3a3";
      base04 = "#9d3fbc";
      base05 = "#09d3e6";
      base06 = "#dead3d";
      base07 = "#f0ca4f";
      base08 = "#ff6e89";
      base09 = "#ff9e64";
      base0A = "#ffca3f";
      base0B = "#a0ff39";
      base0C = "#00d9ff";
      base0D = "#6f9fff";
      base0E = "#9255ff";
      base0F = "#40ebff";
    };
    targets.chromium.enable = true;
  };
}
