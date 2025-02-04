{ pkgs, ... }:
pkgs.stdenv.mkDerivation {
  name = "files";
  src = ../files;
  buildPhase = "true"; # Do nothing.
  installPhase = ''
    mkdir -p $out
    cp -r $src/* $out/
  '';
}
