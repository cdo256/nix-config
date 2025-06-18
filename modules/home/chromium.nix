{ pkgs, ... }:
{
  programs.brave = {
    enable = true;
    package = pkgs.brave;
    # Unencrypted password store.
    commandLineArgs = [ "--password-store=basic" ];
  };
}
