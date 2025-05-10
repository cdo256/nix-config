{ self, ... }:
defaultDir: path:
let
  dir = if builtins.isString defaultDir then self + ("/" + defaultDir) else defaultDir;
in
if builtins.isString path then dir + ("/" + path) else path
