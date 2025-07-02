{
  flake,
  args,
  pkgs,
  config,
  ...
}:

let
  inherit (flake.packages.${args.arch}) files;
  symlink = config.lib.file.mkOutOfStoreSymlink;
in
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
      da = "direnv allow";
      nfu = "nix flake update";
      develop = "nix develop -c fish";
    };
    functions = {
      fish_prompt = {
        body = ''
          #Save the return status of the previous command
          set -l last_pipestatus $pipestatus
          set -lx __fish_last_status $status # Export for __fish_print_pipestatus.

          if functions -q fish_is_root_user; and fish_is_root_user
              printf '%s@%s %s%s%s# ' $USER (prompt_hostname) (set -q fish_color_cwd_root
                                                               and set_color $fish_color_cwd_root
                                                               or set_color $fish_color_cwd) \
                  (prompt_pwd) (set_color normal)
          else
              set -l status_color (set_color $fish_color_status)
              set -l statusb_color (set_color --bold $fish_color_status)
              set -l pipestatus_string (__fish_print_pipestatus "[" "]" "|" "$status_color" "$statusb_color" $last_pipestatus)

              printf '[%s] %s%s@%s %s%s %s%s%s \n> ' (date "+%H:%M:%S") (set_color brblue) \
                  $USER (prompt_hostname) (set_color $fish_color_cwd) $PWD $pipestatus_string \
                  (set_color normal)
          end
        '';
      };
    };
  };

  home.file.".config/fish/fish_variables".source =
    symlink "${config.home.homeDirectory}/sync/config/fish/fish_variables";

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
