{ config, pkgs, ... }:

{
  # Allow unfree packages
  nixpkgs.config.allowUnfree = true;

  # Import hardware configuration
  imports =
    [ ./hardware-configuration.nix ];

  # Define the system state version
  system.stateVersion = "24.05"; # Update this to match your NixOS version

  # Boot loader configuration
  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;

  # Network configuration
  networking.hostName = "nixos"; # Set your desired hostname
  networking.networkmanager.enable = true; # Enable NetworkManager for networking

  # Timezone and locale settings
  time.timeZone = "Europe/London";
  i18n.defaultLocale = "en_GB.UTF-8";

  # Console keymap
  console.keyMap = "uk";

  # User configuration
  users.users.cdo = {
    isNormalUser = true;
    extraGroups = [ "wheel" ]; # Add user to wheel group for sudo access
    shell = pkgs.fish; # Set the default shell to fish
  };

  # Environment packages
  environment.systemPackages = with pkgs; [
    vim          # Text editor
    wget         # Command-line utility for downloading files
    git          # Version control system
    google-chrome # Google Chrome browser
  ];

  # Enable services
  services.xserver.enable = true;
  services.xserver.displayManager.lightdm.enable = true; # Use LightDM as display manager
}