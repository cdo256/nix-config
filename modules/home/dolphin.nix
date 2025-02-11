{ pkgs, ... }:
{
  qt = {
    enable = true;
    platformTheme.name = "adwaita";
    style = {
      name = "adwaita-dark";
    };
  };
  xdg.mimeApps.defaultApplications."inode/directory" = "org.kde.dolphin.desktop";
  environment.systemPackages = [
    pkgs.kdePackages.dolphin
    pkgs.kdePackages.qtwayland
  ];
}
