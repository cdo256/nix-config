{ pkgs, ... }:

{
  environment.systemPackages = with pkgs; [
    lan-mouse
  ];

  networking.firewall.allowedTCPPorts = [ 4242 ];
  networking.firewall.allowedUDPPorts = [ 4242 ];
}