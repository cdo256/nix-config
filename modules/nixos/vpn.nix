{
  services.openvpn = {
    servers.surfshark = {
      config = ''
        config /etc/openvpn/uk-man.prod.surfshark.com_tcp.ovpn
        auth-user-pass /etc/openvpn/surfshark.pass
      '';
    };
  };
}
