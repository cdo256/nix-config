{ config, ... }:
{
  programs.jujutsu = {
    enable = true;
    settings = {
      user.name = config.home.fullName;
      user.email = config.home.mainEmail;
      ui.color = "always";
      ui.defalt-command = [ "st" ];
    };
  };
}
