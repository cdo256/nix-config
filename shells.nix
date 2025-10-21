{
  self,
  inputs,
  ...
}:
{
  perSystem =
    {
      self',
      pkgs,
      system,
      ...
    }:
    {
      devShells = {
        default = pkgs.mkShell {
          nativeBuildInputs = [
            pkgs.gnumake
            pkgs.sops
            pkgs.just
            inputs.nh.packages.${system}.nh
            pkgs.screen
            pkgs.restic
            self'.packages.python-utils
            self'.packages.home-manager
          ];
        };
        python-utils =
          let
            python = pkgs.python3.withPackages (ps: [
              ps.setuptools
              ps.pyyaml
              ps.pypandoc
              pkgs.pandoc
              pkgs.sops
            ]);
          in
          pkgs.mkShell {
            inputsFrom = [ self'.packages.python-utils ];
            packages = [
              python
            ];
            shellHook = ''
              export PYTHONPATH=${toString self}/packages/python-utils/src:$PYTHONPATH
              echo "Development mode with your source tree available"
            '';
          };
      };
    };
}
