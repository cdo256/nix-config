{ flake, ... }:
{
  programs.git = {
    enable = true;
    userName = flake.vars.fullname;
    userEmail = flake.vars.email;
  };
  extraConfig = {
    init.defaultBranch = "main";
    pull.ff = true;
    pull.rebase = "true";
    push.autoSetupRemote = true;
  };
}
