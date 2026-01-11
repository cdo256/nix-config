{
  pkgs,
  args,
  flake,
  ...
}:
let
  files = flake.packages.${args.arch}.files;
in
{
  home.file.".XCompose".source = "${files}/xcompose";
  i18n.inputMethod = {
    enabled = "fcitx5";
    fcitx5.addons = with pkgs; [
      fcitx5-gtk # Crucial for Chrome/Electron
      qt6Packages.fcitx5-configtool
    ];
  };

  # Fcitx5 automatically sets the correct variables, but you can force them to be safe:
  home.sessionVariables = {
    GTK_IM_MODULE = "fcitx";
    QT_IM_MODULE = "fcitx";
    XMODIFIERS = "@im=fcitx";
  };
}
