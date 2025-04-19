{
  inputs,
  pkgs,
  args,
  config,
  ...
}:
let
  inherit (inputs.nixpkgs.lib)
    mkOption
    types
    ;
in
{
  options.home = {
    defaults = mkOption {
      type = types.attrs;
    };
  };
  config = {
    home = {
      username = "cdo";
      defaults = {
        editor = "${inputs.nixvim.packages.${args.arch}.default}/bin/nvim";
        browser = "${pkgs.brave}/bin/brave";
        terminal = "${pkgs.kitty}/bin/kitty";
        desktop = "sway";
        launcher = "${pkgs.wofi}/bin/wofi";
        fileManager = "${pkgs.kdePackages.dolphin}/bin/dolphin";
        emailProgram = "${pkgs.thunderbird}/bin/thunderbird";
        passwordManager = "${pkgs.keepassxc}/bin/keepassxc";
      };
      sessionVariables = {
        EDITOR = config.home.defaults.editor;
        BROWSER = config.home.defaults.browser;
        TERMINAL = config.home.defaults.terminal;
      };
  };
}
