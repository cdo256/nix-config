{ self, ... }:
let
  vars = {
    username = "cdo";
    fullname = "Christina O'Donnell";
    email = "cdo@mutix.org";
  };
in
{
  flake.vars = vars;
  perSystem._module.args.vars = vars;
}
