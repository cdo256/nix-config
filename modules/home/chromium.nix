{ pkgs, ... }:
{
  programs.chromium = {
    enable = true;
    package = pkgs.chromium;
    # Unencrypted password store.
    commandLineArgs = [ "--password-store=basic" ];
  };
}
