{
  self,
  inputs,
  ...
}:
{
  perSystem =
    { pkgs, system, ... }:
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
          ];
        };
      };
    };
}
