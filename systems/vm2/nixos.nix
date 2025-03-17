let
  arch = "x86_64-linux";
in
{
  config = {
    args = {
      inherit arch;
      type = "vm";
      owner = "cdo";
    };
    services.printing.enable = true;
  };
}
