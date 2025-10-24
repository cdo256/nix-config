{ config, ... }:
{
  programs.gnupg.agent = {
    enable = true;
    enableSSHSupport = true;
  };

  services.openssh = {
    enable = true;
    settings = {
      # TODO: Disable this inthe future.
      PasswordAuthentication = true;
      PermitRootLogin = "no";
    };
  };
}
