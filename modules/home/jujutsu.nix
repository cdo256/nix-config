{ flake, ... }:
{
  programs.jujutsu = {
    enable = true;
    settings = {
      user.name = flake.vars.fullname;
      user.email = flake.vars.email;
    };
  };
}
