{
  systemd.oomd = {
    enable = true;
    enableRootSlice = true;
    enableUserSlices = true;
    extraConfig = {
      SwapusedLimit = "60%";
    };
  };
  services.earlyoom = {
    enable = true;
    freeSwapThreshold = 5; # Percent swap free before action.
    freeMemThreshold = 5; # Percent ram free before action.
    #TODO: More patterns?
    extraArgs = [
      "-g"
      "--prefer '^brave|chrome|chromium|firefox|nix-daemon|nix$'"
      "--avoid '^sway|hyprland|kitty$'"
    ];
  };
}
