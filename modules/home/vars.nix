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
      type = types.attrsOf types.anything;
      default = {
        shellProgram = pkgs.bash;
        editor = "${pkgs.neovim}/bin/nvim";
        browser = "${pkgs.brave}/bin/brave";
        terminal = "${pkgs.kitty}/bin/kitty";
        desktop = "sway";
        launcher = "${pkgs.wofi}/bin/wofi";
        fileManager = "${pkgs.kdePackages.dolphin}/bin/dolphin";
        emailProgram = "${pkgs.thunderbird}/bin/thunderbird";
        passwordManager = "${pkgs.keepassxc}/bin/keepassxc";
        diffTool = "${pkgs.neovim}/bin/nvim -d";
        mergeTool = "${pkgs.neovim}/bin/nvim -d";
      };
    };
    mainEmail = mkOption {
      type = types.str;
    };
    fullName = mkOption {
      type = types.str;
    };
    # From https://github.com/NixOS/nixpkgs/blob/7650c61104186974b24d9ba97f6a2ea018581f09/nixos/modules/services/x11/xserver.nix
    kbLayout = {
      layout = mkOption {
        type = types.str;
        default = "us";
        description = ''
          X keyboard layout, or multiple keyboard layouts separated by commas.
        '';
      };

      model = mkOption {
        type = types.str;
        default = "pc104";
        example = "presario";
        description = ''
          X keyboard model.
        '';
      };

      options = mkOption {
        type = types.commas;
        default = "terminate:ctrl_alt_bksp";
        example = "grp:caps_toggle,grp_led:scroll";
        description = ''
          X keyboard options; layout switching goes here.
        '';
      };

      variant = mkOption {
        type = types.str;
        default = "";
        example = "colemak";
        description = ''
          X keyboard variant.
        '';
      };
    };
  };
  config = {
    home = {
      sessionVariables = {
        EDITOR = config.home.defaults.editor;
        BROWSER = config.home.defaults.browser;
        TERMINAL = config.home.defaults.terminal;
        DIFF_TOOL = config.home.defaults.diffTool;
        MERGE_TOOL = config.home.defaults.mergeTool;
      };
    };
  };
}
