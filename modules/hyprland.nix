{
  pkgs,
  inputs,
  system,
  ...
}:

# TODO: Keybindings.

let
  hyprland-pkgs = inputs.hyprland.inputs.nixpkgs.legacyPackages.${system};
  terminal = "${pkgs.kitty}/bin/kitty";
  browser = "${pkgs.brave}/bin/brave";
  launcher = "${pkgs.wofi}/bin/wofi";
  fileManager = "${pkgs.dolphin}/bin/dolphin";
  menu = "${launcher} -S run";
in
{
  #programs.hyprland = {
  #  enable = true;
  #  package = inputs.hyprland.packages.${system}.hyprland;
  #  portalPackage = inputs.hyprland.packages.${system}.xdg-desktop-portal-hyprland;
  #  xwayland.enable = true;
  #};
  wayland.windowManager.hyprland = {
    enable = true;
    settings = {
      exec = [
        #FIXME: This is a hack. hyprland needs to implement an exec-reload keyword.
        "pkill nm-applet; ${pkgs.networkmanagerapplet}/bin/nm-applet --indicator &"
        "pkill waybar; ${pkgs.waybar}/bin/waybar &"
        "pkill dunst; ${pkgs.dunst}/bin/dunst"
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
        "SUPER, T, exec, ${terminal}"
        "SUPER, B, exec, ${browser}"
        "SUPER, C, killactive,"
        "SUPER, M, exit,"
        "SUPER, E, exec, ${fileManager}"
        "SUPER, V, togglefloating,"
        "SUPER, R, exec, ${menu}"
        "SUPER, P, pseudo, # dwindle"
        "SUPER, J, togglesplit, # dwindle"
        "SUPER, F4, killactive"

        # Move focus with mainMod + arrow keys
        "SUPER, left, movefocus, l"
        "SUPER, right, movefocus, r"
        "SUPER, up, movefocus, u"
        "SUPER, down, movefocus, d"

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
        "SUPER, S, togglespecialworkspace, magic"
        "SUPER SHIFT, S, movetoworkspace, special:magic"

        # Scroll through existing workspaces with mainMod + scroll"
        "SUPER, mouse_down, workspace, e+1"
        "SUPER, mouse_up, workspace, e-1"
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
    pkgs.waybar
    pkgs.kitty # Default terminal
    pkgs.dunst # Notification daemon
    pkgs.libnotify
    pkgs.wofi # Launcher
    pkgs.swww # Wallpaper daemon
  ];
  xdg.portal.configPackages = [ pkgs.gnome-session ];
  #sessionVariables = {
  #  NIXOS_OZONE_WL = "1";
  #};
  #hardware.opengl = {
  #  enable = true;
  #  package = hyprland-pkgs.mesa.drivers;
  #  driSupport32Bit = true;
  #  package32 = hyprland-pkgs.pkgsi686Linux.mesa.drivers;
  #};
}
