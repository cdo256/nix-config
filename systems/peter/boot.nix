{
  pkgs,
  ...
}:
{
  config.boot = {
    loader = {
      systemd-boot.enable = true;
      efi.canTouchEfiVariables = true;
    };
  };
  config.environment.systemPackages = [
    pkgs.grub2
    pkgs.os-prober
  ];
}
