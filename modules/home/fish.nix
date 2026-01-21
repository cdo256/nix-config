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
      da = "direnv allow";
      dr = "direnv reload";
      nfu = "nix flake update";
      nd = "nix develop -c fish";
      zed = "zed";
    };
    shellAliases = {
      usd = "systemctl --user";
      ujd = "journalctl --user";
      ssd = "sudo systemctl";
      sjd = "sudo journalctl";
    };
    functions = {
      cdo-list-used-nix-pkgs = {
        body = ''
          for pkg in (history | string match -r -a 'nixpkgs#([\w.-]+)' | string replace -r '.*#' "" | sort -u)
            rg -qF -- "$pkg" ~/.config/mutix; or echo "$pkg"
          end
        '';
      };
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
    pkgs.fishPlugins.foreign-env # for direnv
    pkgs.fishPlugins.done # system notifications
    pkgs.fzf
    pkgs.fishPlugins.fzf-fish
    pkgs.grc # output coloring
    pkgs.fishPlugins.grc

    # Other plugins
    #pkgs.fishPlugins.autopair
    #pkgs.fishPlugins.forgit
    #pkgs.fishPlugins.hydro
  ];
}
