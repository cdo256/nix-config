# Derived from https://github.com/jvanbruegge/nix-config
{
  ...
}:
let modules =
{
  "sway/window" = {
    max-length = 50;
  };
  tray = {
    show-passive-items = true;
    icon-size = 20;
  };
  clock.format = "{:%a  %Y-%m-%d  %H:%M}";
  network = {
    "format-wifi" = "{essid} ({signalStrength}%) ";
    "format-ethernet" = "{ifname}";
  };
  pulseaudio = {
    format = "{volume}% {icon} {format_source}";
    format-muted = "Muted  {format_source}";
    format-icons = {
      headphones = "";
      default = [
        ""
        ""
      ];
    };
    format-source = "- ";
    format-source-muted = "- ";
  };
};
in
{
  programs.waybar = {
    enable = true;
    systemd.enable = true;
    systemd.target = "sway-session.target";

    settings = [
      ({
        layer = "top";
        modules-left = [
          "sway/workspaces"
          "sway/mode"
          "sway/window"
        ];
        modules-center = [ "clock" ];
        modules-right = [
          "tray"
          "network"
          "pulseaudio"
          "battery"
        ];
        height = 24;
      } // modules)
    ];
  };
}
