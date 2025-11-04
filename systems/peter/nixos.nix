{
  config,
  ...
}:
{
  config = {
    services = {
      printing.enable = true;
      syncnet.enable = true;
      borgbase.enable = true;
    };
    fonts.fontconfig.subpixel.rgba = "rgb";
    fonts.fontconfig.subpixel.lcdfilter = "default";
  };
}
