# From https://github.com/jvanbruegge/nix-config/tree/master/sway
_: {
  users.users.greeter = {
    group = "greeter";
    isSystemUser = true;
  };

  services.greetd = {
    enable = false;
    settings = {
      default_session = {
        command = ''
          ${pkgs.greetd.tuigreet}/bin/tuigreet --time --cmd "dbus-run-session sway"
        '';
      };
    };
  };
}
