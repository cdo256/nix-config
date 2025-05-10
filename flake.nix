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
    flake-parts = {
      type = "github";
      owner = "hercules-ci";
      repo = "flake-parts";
      ref = "main";
    };
    systems = {
      type = "github";
      owner = "nix-systems";
      repo = "default";
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
      owner = "cdo256";
      repo = "nh";
      ref = "build-vm";
    };
  };
}
