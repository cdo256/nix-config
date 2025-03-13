{
  config,
  args,
  flake,
  ...
}:
let
  files = flake.packages.${args.arch}.files;
  symlink = config.lib.file.mkOutOfStoreSymlink;
in
{
  home.homeDirectory = "/home/${config.home.username}";
  xdg.enable = true;
  xdg.userDirs = {
    enable = true;
    download = "${config.home.homeDirectory}/downloads";
    pictures = "${config.home.homeDirectory}/images";
    templates = "${config.home.homeDirectory}";
    videos = "${config.home.homeDirectory}";
    desktop = "${config.home.homeDirectory}";
    documents = "${config.home.homeDirectory}";
    music = "${config.home.homeDirectory}";
    createDirectories = true;
  };
  home.sessionVariables = {
    BASH_HISTORY = "${config.xdg.configHome}/shell/histfile";
    GNUPGHOME = "${config.home.homeDirectory}/.local/secure/gnupg";
    HISTFILE = "${config.xdg.stateHome}/shell/histfile";
    MAILDIR = "${config.xdg.dataHome}/mail/"; # Trailing slash required.
    SPACEMACSDIR = "${config.xdg.configHome}/spacemacs";
  };

  home.file = {
    "sync/.stignore" = {
      source = builtins.toFile "stignore" "
        s9
        a34
        org
        org-roam
        secure
      ";
    };
    ".config/sway" = {
      source = "${files}/sway";
      recursive = true;
    };
    ".config/spacemacs" = {
      source = "${files}/spacemacs";
      recursive = true;
    };
    ".config/git" = {
      source = "${files}/git";
      recursive = true;
    };
    #".config/nvim" = {
    #  source = "${files}/nvim";
    #  recursive = true;
    #};
    #".config/hypr" = {
    #  source = "${files}/hypr";
    #  recursive = true;
    #};

    ".thunderbird".source = symlink "${config.home.homeDirectory}/.config/thunderbird";
    ".mozilla/firefox".source = symlink "${config.home.homeDirectory}/.config/firefox";
  };
}
