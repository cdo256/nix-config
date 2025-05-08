{
  pkgs,
  ...
}:

{
  programs.fish = {
    enable = true;
    loginShellInit = ''
      set -x PATH ~/.local/bin $PATH
      set -x GPG_TTY (tty)
      set -g fish_key_bindings fish_vi_key_bindings
      direnv hook fish | source
    '';
    shellAbbrs = {
      gla = "git log --graph --all --simplify-by-decoration --oneline";
      lg = "lazygit";
      nv = "nvim";
      usd = "systemctl --user";
      ujd = "journalctl --user";
      ssd = "sudo systemctl";
      sjd = "sudo journalctl";
      zed = "zeditor";
    };
  };

  home.packages = [
    # Stable
    pkgs.fish
    pkgs.fzf
    pkgs.fishPlugins.foreign-env

    # Trying
    pkgs.fishPlugins.done
    pkgs.fishPlugins.autopair
    pkgs.fishPlugins.fzf-fish
    pkgs.fishPlugins.forgit
    pkgs.fishPlugins.hydro
    pkgs.grc
    pkgs.fishPlugins.grc
  ];
}
