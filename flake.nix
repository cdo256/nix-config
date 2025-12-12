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
      owner = "cdo256";
      repo = "nixpkgs";
      ref = "mutix"; # following nixos-unstable.
    };
    # For mesa, since mesa 25 has flickering issues with Zed+wayland.
    #FIXME: See https://github.com/zed-industries/zed/issues/32792.
    nixpkgs-24-11 = {
      type = "github";
      owner = "nixos";
      repo = "nixpkgs";
      ref = "24.11";
    };
    lix-module = {
      url = "https://git.lix.systems/lix-project/nixos-module/archive/2.93.3-2.tar.gz";
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
      owner = "nix-community";
      repo = "home-manager";
      ref = "master";
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
    #TODO: Drop these dependencies.
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
    cdo-secrets = {
      type = "github";
      owner = "cdo256";
      repo = "private";
      ref = "main";
      flake = false;
    };
    stylix = {
      type = "github";
      owner = "cdo256";
      repo = "stylix";
      ref = "master";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    zed-extensions = {
      type = "github";
      owner = "DuskSystems";
      repo = "nix-zed-extensions";
      ref = "main";
    };
    plasma-manager = {
      type = "github";
      owner = "nix-community";
      repo = "plasma-manager";
      ref = "trunk";
    };
    just-agda = {
      type = "github";
      owner = "cdo256";
      repo = "just-agda";
      ref = "main";
    };
    git-reflection = {
      type = "github";
      owner = "cdo256";
      repo = "git-reflection";
      ref = "main";
    };
  };
}
