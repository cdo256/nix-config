{ inputs, pkgs, args, ... }:
{
  config = {
    home = {
      username = "cdo";
      fullName = "Christina O'Donnell";
      mainEmail = "cdo@mutix.org";

      defaults = if args.graphical then {
        shellPackage = pkgs.fish;
        shell = "${pkgs.fish}/bin/fish";
        editor = "${inputs.nixvim.packages.${args.arch}.default}/bin/nvim";
        browser = "${pkgs.brave}/bin/brave";
        terminal = "${pkgs.kitty}/bin/kitty";
        desktop = "sway";
        launcher = "${pkgs.wofi}/bin/wofi";
        fileManager = "${pkgs.kdePackages.dolphin}/bin/dolphin";
        emailProgram = "${pkgs.thunderbird}/bin/thunderbird";
        passwordManager = "${pkgs.keepassxc}/bin/keepassxc";
        diffTool = "${pkgs.neovim}/bin/nvim -d";
        mergeTool = "${pkgs.neovim}/bin/nvim -d";
      } else {
        shellPackage = pkgs.fish;
        shell = "${pkgs.fish}/bin/fish";
        editor = "${pkgs.vim}/bin/vim";
      };

      kbLayout = {
        layout = "gb";
        variant = "";
        options = "caps:escape";
      };
    };
  };
}
