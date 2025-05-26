{
  description = "Nixos config flake";

  outputs =
    inputs:
    inputs.flake-parts.lib.mkFlake { inherit inputs; } {
      imports = [ ./outputs.nix ];
    };

  inputs = {
    nixpkgs = {
      type = "github";
      owner = "nixos";
      repo = "nixpkgs";
      ref = "nixos-unstable";
    };
    lix-module = {
      url = "https://git.lix.systems/lix-project/nixos-module/archive/2.93.0.tar.gz";
      #url = "https://git.lix.systems/lix-project/lix/src/branch/main";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    flake-parts = {
      type = "github";
      owner = "hercules-ci";
      repo = "flake-parts";
      ref = "main";
    };
    home-manager = {
      type = "github";
      owner = "cdo256";
      repo = "home-manager";
      ref = "backup-command";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    nixvim = {
      type = "github";
      owner = "cdo256";
      repo = "nixvim-config";
      ref = "main";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    sops-nix = {
      type = "github";
      owner = "Mic92";
      repo = "sops-nix";
      ref = "master";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    hyprland = {
      type = "github";
      owner = "hyprwm";
      repo = "hyprland";
      ref = "main";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    hyprpanel = {
      type = "github";
      owner = "Jas-SinghFSU";
      repo = "HyprPanel";
      ref = "master";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    nh = {
      type = "github";
      owner = "nix-community";
      repo = "nh";
      ref = "master";
    };
    cdo-private = {
      type = "github";
      owner = "cdo256";
      repo = "private";
      ref = "main";
      flake = false;
    };
    stylix = {
      type = "github";
      owner = "danth";
      repo = "stylix";
      ref = "master";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };
}
