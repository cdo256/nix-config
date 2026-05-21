{ pkgs, ... }:

pkgs.stdenvNoCC.mkDerivation {
  pname = "opencode-dir";
  version = "1.0.10";
  src = pkgs.fetchurl {
    url = "https://registry.npmjs.org/opencode-dir/-/opencode-dir-1.0.10.tgz";
    hash = "sha256-For+VcnEse4+usbvdjc/A6yE50qF6GRWxK7egkT0Ihs=";
  };

  sourceRoot = "package";

  installPhase = ''
    runHook preInstall
    mkdir -p $out/lib/node_modules/opencode-dir
    cp -r ./* $out/lib/node_modules/opencode-dir/
    runHook postInstall
  '';
}
