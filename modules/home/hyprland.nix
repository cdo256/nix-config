{
  pkgs,
  args,
  inputs,
  system,
  ...
}:

let
  hyprland-pkgs = inputs.hyprland.inputs.nixpkgs.legacyPackages.${system};
  terminal = "${pkgs.kitty}/bin/kitty";
  browser = "${pkgs.brave}/bin/brave";
  launcher = "${pkgs.wofi}/bin/wofi";
  fileManager = "${pkgs.kdePackages.dolphin}/bin/dolphin";
  emailProgram = "${pkgs.thunderbird}/bin/thunderbird";
  passwordManager = "${pkgs.keepassxc}/bin/keepassxc";
  menu = "${launcher} -S run";
  createWorkspace = pkgs.writeShellApplication {
    name = "create-workspace";
    runtimeInputs = [
      pkgs.hyprland
      pkgs.wofi
      pkgs.jq
    ];
    text = ''
      echo running >/tmp/y
      workspaces=/tmp/x #$(mktemp)
      hyprctl -j workspaces | jq '.[].name' | tr -d '"' >"$workspaces"
      new=$(wofi -d <"$workspaces")
      hyprctl dispatch workspace name:"$new"
    '';
  };
in
{
  wayland.windowManager.hyprland = {
    enable = args.graphical;
    settings = {
      exec-once = [
        "${pkgs.networkmanagerapplet}/bin/nm-applet --indicator &"
        #"${pkgs.hyprpanel}/bin/hyprpanel &"
        "${passwordManager} &"
      ];
      env = [
        "XCURSOR_SIZE,24"
        "HYPRCURSOR_SIZE,24"
      ];
      input = {
        kb_layout = "gb";
        follow_mouse = "1";
      };
      bind = [
        "SUPER SHIFT, T, exec, ${terminal}"
        "SUPER SHIFT, F, exec, ${browser}"
        "SUPER SHIFT, E, exec, ${fileManager}"
        "SUPER SHIFT, W, exec, ${emailProgram}"
        "SUPER SHIFT, V, togglefloating,"
        "SUPER, R, exec, ${menu}"
        #"SUPER, P, pseudo, # dwindle"
        #"SUPER, J, togglesplit, # dwindle"
        #"SUPER, D, killactive,"
        "SUPER, F4, killactive,"
        "SUPER ALT, F4, killactive,"
        "ALT, F4, killactive,"
        "SUPER ALT SHIFT, F4, exit,"
        "SUPER CTRL, F4, exec, sudo systemctl suspend"

        # Move focus
        "SUPER, left, movefocus, l"
        "SUPER, up, movefocus, u"
        "SUPER, down, movefocus, d"
        "SUPER, right, movefocus, r"
        "SUPER, H, movefocus, l"
        "SUPER, J, movefocus, d"
        "SUPER, K, movefocus, u"
        "SUPER, L, movefocus, r"

        # Move window
        "SUPER SHIFT, left, movewindow, l"
        "SUPER SHIFT, up, movewindow, u"
        "SUPER SHIFT, down, movewindow, d"
        "SUPER SHIFT, right, movewindow, r"
        "SUPER SHIFT, H, movewindow, l"
        "SUPER SHIFT, J, movewindow, d"
        "SUPER SHIFT, K, movewindow, u"
        "SUPER SHIFT, L, movewindow, r"

        "SUPER SHIFT, EQUAL, exec, ${createWorkspace}/bin/create-workspace"

        # Switch workspaces with mainMod + [0-9]
        "SUPER, 1, workspace, 1"
        "SUPER, 2, workspace, 2"
        "SUPER, 3, workspace, 3"
        "SUPER, 4, workspace, 4"
        "SUPER, 5, workspace, 5"
        "SUPER, 6, workspace, 6"
        "SUPER, 7, workspace, 7"
        "SUPER, 8, workspace, 8"
        "SUPER, 9, workspace, 9"
        "SUPER, 0, workspace, 10"

        # Move active window to a workspace with mainMod + SHIFT + [0-9]
        "SUPER SHIFT, 1, movetoworkspace, 1"
        "SUPER SHIFT, 2, movetoworkspace, 2"
        "SUPER SHIFT, 3, movetoworkspace, 3"
        "SUPER SHIFT, 4, movetoworkspace, 4"
        "SUPER SHIFT, 5, movetoworkspace, 5"
        "SUPER SHIFT, 6, movetoworkspace, 6"
        "SUPER SHIFT, 7, movetoworkspace, 7"
        "SUPER SHIFT, 8, movetoworkspace, 8"
        "SUPER SHIFT, 9, movetoworkspace, 9"
        "SUPER SHIFT, 0, movetoworkspace, 10"

        # Example special workspace (scratchpad)"
        # TODO: How to get windows out of the scratchpad?!
        "SUPER, S, togglespecialworkspace, magic"
        "SUPER SHIFT, S, movetoworkspace, special:magic"

        # Scroll through existing workspaces with mainMod + scroll"
        "SUPER ALT, mouse_down, workspace, e+1"
        "SUPER ALT, mouse_up, workspace, e-1"
        "SUPER ALT SHIFT, mouse_down, movetoworkspace, e+1"
        "SUPER ALT SHIFT, mouse_up, movetoworkspace, e-1"
        "SUPER ALT, left, workspace, e-1"
        "SUPER ALT, right, workspace, e+1"
        "SUPER ALT SHIFT, left, movetoworkspace, e-1"
        "SUPER ALT SHIFT, right, movetoworkspace, e+1"
        "SUPER ALT, O, workspace, e-1"
        "SUPER ALT, P, workspace, e+1"
        "SUPER ALT SHIFT, O, movetoworkspace, e-1"
        "SUPER ALT SHIFT, P, movetoworkspace, e+1"
        "SUPER, O, workspace, e-1"
        "SUPER, P, workspace, e+1"
        "SUPER SHIFT, O, movetoworkspace, e-1"
        "SUPER SHIFT, P, movetoworkspace, e+1"

        # Move workspaces between monitors
        "SUPER SHIFT, [,  movecurrentworkspacetomonitor, -1"
        "SUPER SHIFT, [,  movecurrentworkspacetomonitor, -1"
        "SUPER ALT SHIFT, ], movecurrentworkspacetomonitor, +1"
        "SUPER ALT SHIFT, ], movecurrentworkspacetomonitor, +1"

        # Grouping
        "SUPER SHIFT, G, togglegroup"
        "SUPER, U, changegroupactive, b"
        "SUPER, I, changegroupactive, f"
        "SUPER ALT SHIFT, left, moveintogroup, l"
        "SUPER ALT SHIFT, up, moveintogroup, u"
        "SUPER ALT SHIFT, down, moveintogroup, d"
        "SUPER ALT SHIFT, right, moveintogroup, r"
        "SUPER ALT SHIFT, H, moveintogroup, l"
        "SUPER ALT SHIFT, J, moveintogroup, d"
        "SUPER ALT SHIFT, K, moveintogroup, u"
        "SUPER ALT SHIFT, L, moveintogroup, r"

        "SUPER, PRINT, exec, hyprshot -m window"
        ", PRINT, exec, hyprshot -m output"
        "SHIFT, PRINT, exec, hyprshot -m region"
      ];
      bindm = [
        # Move/resize windows with mainMod + LMB/RMB and dragging
        "SUPER, mouse:272, movewindow"
        "SUPER, mouse:273, resizewindow"
      ];

    };
  };
  xdg.portal = {
    enable = true;
    extraPortals = [ pkgs.xdg-desktop-portal-gtk ];
  };
  home.packages = [
    pkgs.hyprshot
    pkgs.jq
    pkgs.grim
    pkgs.slurp
    pkgs.wl-clipboard
    pkgs.kitty # Default terminal
    pkgs.dunst # Notification daemon
    pkgs.libnotify
    pkgs.wofi # Launcher
    pkgs.swww # Wallpaper daemon
    pkgs.waybar
  ];
  xdg.portal.configPackages = [ pkgs.gnome-session ];
}
