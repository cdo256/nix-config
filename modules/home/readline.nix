{
  programs.readline = {
    enable = true;

    bindings = {
      "J" = "history-search-backward";
      "K" = "history-search-forward";
      "TAB" = "menu-complete";
      "<shift-tab>" = "menu-complete-backward";
    };

    variables = {
      "editing-mode" = "vi";
      "show-mode-in-prompt" = "on";

      # \e[5 - makes the curosr a bar
      # \e[1 - makes the curosr a rectangle
      "vi-ins-mode-string" = "[I] \\1\\e[5 q\\2";
      "vi-cmd-mode-string" = "[N] \\1\\e[1 q\\2";

      "colored-stats" = "on";
      "completion-ignore-case" = "on";
      "show-all-if-ambiguous" = "on";
      "bell-style" = "none";
    };

    extraConfig = ''
      $if mode=vi
        set keymap vi-command
        "v": edit-and-execute-command
      $endif
    '';
  };
}
