{
  self,
  ...
}@inputs:
{
  perSystem =
    { pkgs, ... }:
    {
      devShells = {
        default = pkgs.mkShell {
          nativeBuildInputs = [
            pkgs.gnumake
            pkgs.sops
            pkgs.just
            pkgs.nh
          ];
        };
      };
    };
}
