{ pkgs, ... }:
{
  qt = {
    enable = true;
  };
  xdg.mime.defaultApplications."inode/directory" = "org.kde.dolphin.desktop";
  environment.systemPackages = [
    pkgs.kdePackages.dolphin
    pkgs.kdePackages.qtwayland
  ];
}
