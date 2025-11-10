{
  inputs,
  pkgs,
  args,
  ...
}:
{
  config = {
    home = {
      username = "example";
      fullName = "Example User";
      mainEmail = "example@example.org";
      defaults = {
        shellPackage = pkgs.fish;
        shell = "${pkgs.fish}/bin/fish";
        editor = "${inputs.nixvim.packages.${args.arch}.default}/bin/nvim";
        browser = "${pkgs.brave}/bin/brave";
        terminal = "${pkgs.kitty}/bin/kitty";
        desktop = "sway";
        launcher = "${pkgs.wofi}/bin/wofi";
        fileManager = "${pkgs.xfce.thunar}/bin/thunar";
        emailProgram = "${pkgs.thunderbird}/bin/thunderbird";
        passwordManager = "${pkgs.keepassxc}/bin/keepassxc";
        diffTool = "${pkgs.neovim}/bin/nvim -d";
        mergeTool = "${pkgs.neovim}/bin/nvim -d";
      };
      kbLayout = {
        layout = "us";
        variant = "";
        options = "caps:escape";
      };
    };
  };
}
