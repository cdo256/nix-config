{
  programs.waybar.settings = [
    {
      battery = {
        bat = "BAT1";
        interval = 10; # Appears to be ignored.
        format = "{capacity}% {icon}";
        format-icons = [ "" "" "" "" "" ];
      };
    }
  ];
}
