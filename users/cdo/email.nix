{ config, pkgs, flake, ... }:
let
  configFile = flake + "/files/mbsyncrc";
in
{
  accounts.email = {
    maildirBasePath = "${config.home.homeDirectory}/.local/data/mail";
    accounts = {
      "cdo-mutix" = {
        primary = true;
        flavor = "plain";
        address = "cdo@mutix.org";
        aliases = [];
        realName = "Christina O'Donnell";
        userName = "cdo@mutix.org";
        passwordCommand = "${pkgs.coreutils}/bin/cat /run/secrets/cdo/mutix-password";
        folders = {
          inbox = "Inbox";
          sent = "Sent";
          drafts = "Drafts";
          trash = "Trash";
        };
        imap.host = "mutix.org";
        imap.port = 993;
        imap.tls.enable = true;
        smtp.host = "mutix.org";
        smtp.port = 465;
        smtp.tls.enable = true;
        smtp.tls.useStartTls = true;
        mbsync = {
          enable = true;
          create = "both";
          remove = "maildir";
          subFolders = "Verbatim";
          #expunge = "both"; # Needs further testing.
        };
        neomutt = {
          enable = true;
          mailboxName = "Inbox";
        };
        #maildir.path = "${config.home.homeDirectory}/.local/data/mail/mutix";
      };
    };
  };

  programs.mbsync = {
    enable = false;
  };
  programs.neomutt = {
    enable = false;
  };
  services.mbsync = {
    enable = false;
    #frequency = "*:0/5";
    configFile = configFile;
  };
}
