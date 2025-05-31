{
  lib,
  pkgs,
}:
pkgs.stdenv.mkDerivation rec {
  pname = "chromium-id-generator";
  version = "0.1.0";

  src = pkgs.fetchFromGitHub {
    owner = "dsoprea";
    repo = "ChromeIdGenerator";
    rev = "d22c81499731bf96ed6cebc758c5e6e5c2566c4f";
    sha256 = "sha256-T0ySs4qPWO1OJh7y12zCn3+R4u/YJhF1EgEIgVZLfXo=";
  };

  nativeBuildInputs = [ pkgs.makeWrapper ];
  buildInputs = [
    pkgs.python3
    pkgs.openssl
  ];

  installPhase = ''
    install -Dm755 extension_id.py $out/bin/chromium-id-generator
    wrapProgram $out/bin/chromium-id-generator \
      --prefix PATH : ${lib.makeBinPath [ pkgs.openssl ]}
  '';

  meta = with lib; {
    description = "Generates Chrome extension IDs from public RSA keys using OpenSSL";
    homepage = "https://github.com/dsoprea/ChromeIdGenerator";
    license = licenses.mit;
    maintainers = [ maintainers.yourname ];
  };
}
