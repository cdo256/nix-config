{ pkgs, ... }:
{
  qt = {
    enable = true;
    platformTheme = "gnome";
    style = "adwaita-dark";
  };
  xdg.mime.defaultApplications."inode/directory" = "org.kde.dolphin.desktop";
  environment.systemPackages = [
    pkgs.kdePackages.dolphin
    pkgs.kdePackages.qtwayland
  ];
}
