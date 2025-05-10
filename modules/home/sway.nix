# Derived from https://github.com/jvanbruegge/nix-config/tree/master/sway
{
  flake,
  inputs,
  config,
  pkgs,
  ...
}:
let
  inherit (inputs.nixpkgs.lib) foldl' getExe;
  inherit (pkgs) writeShellScriptBin;
  inherit (config.home) defaults;
  swaylock = "${pkgs.swaylock}/bin/swaylock";
  pamixer = "${pkgs.pamixer}/bin/pamixer";
  brightnessctl = "${pkgs.brightnessctl}/bin/brightnessctl";
  playerctl = "${pkgs.playerctl}/bin/playerctl";
  batsignal = "${pkgs.batsignal}/bin/batsignal";
  menu = "${defaults.launcher} -S run";
  swaymsg = "${pkgs.sway}/bin/swaymsg";

  rename-workspace = writeShellScriptBin "rename-workspace" ''
    name=''$(${defaults.launcher} -d </dev/null)
    ${swaymsg} rename workspace to \$name
  '';

  change-workspace = writeShellScriptBin "change-workspace" ''
    workspace=''$(${swaymsg} -t get_workspaces | ${pkgs.jq}/bin/jq '.[].name' | ${pkgs.coreutils}/bin/tr -d '"' | ${defaults.launcher} -d)
    ${swaymsg} workspace ''${workspace}
  '';

  mergeAttrs = foldl' (a: b: a // b) { };
  numerals = [
    "0"
    "1"
    "2"
    "3"
    "4"
    "5"
    "6"
    "7"
    "8"
    "9"
  ];
  directions = [
    {
      dir = "left";
      vimkey = "h";
    }
    {
      dir = "down";
      vimkey = "j";
    }
    {
      dir = "up";
      vimkey = "k";
    }
    {
      dir = "right";
      vimkey = "l";
    }
  ];
  alt = "Mod1";
  super = "Mod4";
  forEachDirection = (
    {
      dir,
      vimkey,
      ...
    }:
    {
      "${super}+${dir}" = "focus ${dir}";
      "${super}+${vimkey}" = "focus ${dir}";
      "${super}+Shift+${dir}" = "move ${dir}";
      "${super}+Shift+${vimkey}" = "move ${dir}";
    }
  );
  forEachNum = (
    num: {
      "${super}+${num}" = "workspace \"${num}\"";
      "${super}+Shift+${num}" = "move container to workspace \"${num}\"; workspace \"${num}\"";
    }
  );
  numericBindings = mergeAttrs (map forEachNum numerals);
  dirBindings = mergeAttrs (map forEachDirection directions);
in
{
  imports = [
    ./waybar.nix
  ];

  home.packages = [
    pkgs.grim
    pkgs.slurp
    pkgs.wl-clipboard
    pkgs.wl-mirror
    pkgs.wofi
    pkgs.pamixer
    pkgs.swaylock
    pkgs.brightnessctl
    pkgs.batsignal
  ];

  # Notify on low battery
  systemd.user.services.batsignal = {
    Install.WantedBy = [ "graphical-session.target" ];
    Unit = {
      Description = "Battery status daemon";
      PartOf = [ "graphical-session.target" ];
    };
    Service = {
      Type = "simple";
      ExecStart = batsignal;
    };
  };

  home.file = {
    ".config/xdg-desktop-portal-wlr/config" = {
      text = ''
        [screencast]
        max_fps=30
        chooser_type=simple
        chooser_cmd=slurp -f %o -or
      '';
    };
  };

  programs.swaylock = {
    enable = true;
    settings = {
      color = "063F62";
      show-failed-attempts = true;
    };
  };

  services.dunst = {
    enable = true;
  };

  services.kanshi = {
    enable = true;
    systemdTarget = "sway-session.target";
  };

  wayland.systemd.target = "sway-session.target";

  wayland.windowManager.sway = {
    enable = true;
    checkConfig = false;
    wrapperFeatures = {
      gtk = true;
      base = true;
    };
    systemd.enable = true;

    config = {
      bars = [ ];
      modifier = super;

      window.border = 0;
      floating.border = 0;

      terminal = getExe config.programs.kitty.package;
      inherit menu;

      input = with config.home.kbLayout; {
        "*" = {
          xkb_layout = layout;
          # FIXME: An empty variant is rejected by sway.
          #xkb_variant = variant;
          xkb_options = options;
          tap = "enabled";
        };
      };

      output."*".bg = "${flake + "/files/wallpaper.png"} fit";

      keybindings =
        numericBindings
        // dirBindings
        // {
          # System controls
          "${super}+Ctrl+F2" = "exec ${change-workspace}";
          "${super}+Ctrl+Shift+F2" = "exec ${rename-workspace}";
          "${super}+Ctrl+F4" = "exit";
          "${super}+Ctrl+F5" = "reload";
          "${super}+Ctrl+F6" = "exec sudo systemctl suspend";
          "${super}+Ctrl+F7" = "exec sudo systemctl poweroff";

          # Launch
          "${super}+Shift+t" = "exec ${defaults.terminal}";
          "${super}+Shift+f" = "exec ${defaults.browser}";
          "${super}+Shift+e" = "exec ${defaults.fileManager}";
          "${super}+Shift+w" = "exec ${defaults.emailProgram}";
          "${super}+r" = "exec ${menu}";

          # App spspecific
          "${super}+${alt}+Shift+v" = "floating toggle";
          "${super}+Shift+F11" = "fullscreen";
          "${super}+Shift+${alt}+z" = "mode resize";
          "${super}+Shift+z" = "splith";
          "${super}+Shift+v" = "splitv";
          "${super}+Shift+${alt}+s" = "layout stacking";
          "${super}+Shift+g" = "layout tabbed";
          "${super}+Shift+${alt}+g" = "layout tabbed";
          "${super}+Shift+${alt}+e" = "layout toggle split";
          "${super}+${alt}+p" = "focus parent";

          "${super}+${alt}+f" = "focus mode_toggle";
          "${super}+Shift+${alt}+f" = "floating toggle";

          "${super}+${alt}+m" = "scratchpad show";
          "${super}+Shift+${alt}+m" = "move to scratchpad";

          # Kill
          "${super}+F4" = "kill";
          "${super}+${alt}+F4" = "kill";
          "${alt}+F4" = "kill";

          # Lock screen
          "${super}+Shift+Return" = "exec ${swaylock}";

          # Screen mirror (untested)
          #"${super}+Shift+p" = "exec wl-mirror $(slurp -o -f '%o')";

          # Move workspaces to other monitors
          "${super}+bracketleft" = "focus output left";
          "${super}+bracketright" = "focus output right";
          "${super}+Shift+bracketleft" = "move workspace to output left";
          "${super}+Shift+bracketright" = "move workspace to output right";

          "${super}+o" = "workspace prev_on_output";
          "${super}+p" = "workspace next_on_output";
          "${super}+Shift+o" = "move container to workspace prev_on_output; workspace prev_on_output";
          "${super}+Shift+p" = "move container to workspace next_on_output; workspace next_on_output";

          # Screenshots
          "Print" = "exec grim -g \"$(slurp)\" - | wl-copy";
          "Shift+Print" =
            "exec mkdir -p ~/images && grim -g \"$(slurp)\" - >~/images/screenshot_$(date -Iseconds).png";

          # Volume control
          "XF86AudioRaiseVolume" = "exec ${pamixer} --increase 5";
          "XF86AudioLowerVolume" = "exec ${pamixer} --decrease 5";
          "XF86AudioMute" = "exec ${pamixer} --toggle-mute";
          "XF86AudioMicMute" = "exec ${pamixer} --toggle-mute --default-source";

          # Laptop brightness
          "XF86MonBrightnessUp" = "exec ${brightnessctl} set '+20%'";
          "XF86MonBrightnessDown" = "exec ${brightnessctl} set '20%-'";

          "XF86AudioPlay" = "exec ${playerctl} play-pause";
          "XF86AudioNext" = "exec ${playerctl} next";
          "XF86AudioPrev" = "exec ${playerctl} previous";
        };

    };
  };
}
