{ ... }:
parent: child:
let
  strlen = builtins.stringLength;
  substr = builtins.substring;
  normalize = path: builtins.replaceStrings [ "//" ] [ "/" ] (path + "/");
  parentNorm = normalize parent;
  childNorm = normalize child;
in
if substr 0 (strlen parentNorm) childNorm == parentNorm then
  substr (strlen parentNorm) (strlen childNorm - strlen parentNorm - 1) childNorm
else
  null
