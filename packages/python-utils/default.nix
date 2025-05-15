{
  pkgs,
  ...
}:
let
  python = pkgs.python3;
in
python.pkgs.buildPythonPackage rec {
  pname = "python-utils";
  version = "0.1.0";
  src = ./.;

  pyproject = true;

  build-system = with python.pkgs; [
    setuptools
  ];

  dependencies = with python.pkgs; [
    pkgs.pandoc
    pypandoc
  ];

  # does not contain any tests
  doCheck = false;

  meta = {
    description = "Christina's Python Utils";
  };
}
