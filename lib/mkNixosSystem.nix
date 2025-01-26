{
  self,
  inputs,
  lib,
  ...
}:
host:
{
  modules ? [ ],
  type,
  ...
}:
lib.nixosSystem { }
