{
  services.openvpn = {
    servers.surfshark = {
      config = ''
        config /etc/openvpn/uk-man.prod.surfshark.com_tcp.ovpn
        auth-user-pass /etc/openvpn/surfshark.pass
      '';
    };
  };
  systemd.services.openvpn-surfshark = {
    enable = false; # FIXME: This needs extra config to get working.
  };
}
