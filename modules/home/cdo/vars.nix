{
  inputs,
  pkgs,
  args,
  ...
}:
{
  home.username = "cdo";
  home.sessionVariables = {
    EDITOR = "${inputs.nixvim.packages.${args.arch}.default}/bin/nvim";
    BROWSER = "${pkgs.brave}/bin/brave";
    TERMINAL = "${pkgs.kitty}/bin/kitty";
  };
}
