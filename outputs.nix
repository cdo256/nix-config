{
  imports = [
    ./args.nix
    ./lib
    ./vars
    ./packages
    ./shells.nix
    ./systems
    #./debug.nix # Suddenly causing a stack overflow
    ./users
  ];
}
