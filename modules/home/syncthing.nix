{
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
  };
}
