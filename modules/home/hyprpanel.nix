# Hyprpanel is the bar on top of the screen
# Display informations like workspaces, battery, wifi, ...
{
  inputs,
  config,
  args,
  ...
}:

{
  programs.hyprpanel = {
    enable = args.graphical;
    systemd.enable = true;
    hyprland.enable = true;
    overwrite.enable = true;
    overlay.enable = true;

    override = {
      "bar.launcher.icon" = "";
      "bar.workspaces.show_numbered" = false;
      "bar.workspaces.workspaces" = 5;
      "bar.workspaces.hideUnoccupied" = false;
      "bar.windowtitle.label" = true;
      "bar.volume.label" = false;
      "bar.network.truncation_size" = 12;
      "bar.bluetooth.label" = false;
      "bar.clock.format" = "%a %b %d  %I:%M %p";
      "bar.notifications.show_total" = true;
      "theme.osd.enable" = true;
      "theme.osd.orientation" = "vertical";
      "theme.osd.location" = "left";
      "theme.osd.margins" = "0px 0px 0px 10px";
      "theme.osd.muted_zero" = true;
      "menus.dashboard.powermenu.confirmation" = false;

      "menus.dashboard.shortcuts.left.shortcut1.icon" = "";
      "menus.dashboard.shortcuts.left.shortcut1.command" = "zen";
      "menus.dashboard.shortcuts.left.shortcut1.tooltip" = "Zen";
      "menus.dashboard.shortcuts.left.shortcut2.icon" = "󰅶";
      "menus.dashboard.shortcuts.left.shortcut2.command" = "caffeine";
      "menus.dashboard.shortcuts.left.shortcut2.tooltip" = "Caffeine";
      "menus.dashboard.shortcuts.left.shortcut3.icon" = "󰖔";
      "menus.dashboard.shortcuts.left.shortcut3.command" = "night-shift";
      "menus.dashboard.shortcuts.left.shortcut3.tooltip" = "Night-shift";
      "menus.dashboard.shortcuts.left.shortcut4.icon" = "";
      "menus.dashboard.shortcuts.left.shortcut4.command" = "menu";
      "menus.dashboard.shortcuts.left.shortcut4.tooltip" = "Search Apps";
      "menus.dashboard.shortcuts.right.shortcut1.icon" = "";
      "menus.dashboard.shortcuts.right.shortcut1.command" = "hyprpicker -a";
      "menus.dashboard.shortcuts.right.shortcut1.tooltip" = "Color Picker";
      "menus.dashboard.shortcuts.right.shortcut3.icon" = "󰄀";
      "menus.dashboard.shortcuts.right.shortcut3.command" = "screenshot region swappy";
      "menus.dashboard.shortcuts.right.shortcut3.tooltip" = "Screenshot";
    };
  };
}
