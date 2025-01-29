{ config, ... }:
{
  home.homeDirectory = "/home/${config.home.username}";
  xdg.enable = true;
  xdg.userDirs = {
    enable = true;
    download = "/home/cdo/downloads";
    pictures = "/home/cdo/images";
    templates = "/home/cdo";
    videos = "/home/cdo";
    desktop = "/home/cdo";
    documents = "/home/cdo";
    music = "/home/cdo";
    createDirectories = true;
  };
  home.sessionVariables = {
    BASH_HISTORY = "${config.xdg.configHome}/shell/histfile";
    GNUPGHOME = "${config.home.homeDirectory}/.local/secure/gnupg";
    HISTFILE = "${config.xdg.stateHome}/shell/histfile";
    MAILDIR = "${config.xdg.dataHome}/mail/"; # Trailing slash required.
    SPACEMACSDIR = "${config.xdg.configHome}/spacemacs";
  };

  #home.file = {
  #  "sync/.stignore" = {
  #    source = builtins.toFile "stignore" "
  #      s9
  #      a34
  #      org
  #      org-roam
  #      secure
  #    ";
  #  };
  #  ".config/sway" = {
  #    source = "${files}/sway";
  #    recursive = true;
  #  };
  #  ".config/spacemacs" = {
  #    source = "${files}/spacemacs";
  #    recursive = true;
  #  };
  #  ".config/git" = {
  #    source = "${files}/git";
  #    recursive = true;
  #  };
  #  #".config/nvim" = {
  #  #  source = "${files}/nvim";
  #  #  recursive = true;
  #  #};
  #  ".config/obs-studio" = {
  #    source = "${files}/obs-studio";
  #    recursive = true;
  #  };
  #  #".config/hypr" = {
  #  #  source = "${files}/hypr";
  #  #  recursive = true;
  #  #};

  #  ".thunderbird".source = symlink "/home/cdo/.config/thunderbird";
  #  ".mozilla/firefox".source = symlink "/home/cdo/.config/firefox";
  #};

}
