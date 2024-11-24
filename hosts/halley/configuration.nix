{ nix, config, lib, pkgs, nixpkgs, stdenv, inputs, ... }:

{
  nixpkgs.config.allowUnfree = true;
  nix.settings.experimental-features = [ "nix-command" "flakes" ];
  system.stateVersion = "24.05";

  boot.loader.grub.enable = true;
  boot.loader.grub.device = "/dev/nvme0n1";
  boot.loader.grub.useOSProber = true;

  boot.initrd.luks.devices."luks-58655766-776f-42ca-96b1-a87a3e21508f".device = "/dev/disk/by-uuid/58655766-776f-42ca-96b1-a87a3e21508f";
  boot.initrd.secrets = {
    "/boot/crypto_keyfile.bin" = null;
  };

  boot.loader.grub.enableCryptodisk = true;
  boot.initrd.luks.devices."luks-26f30444-e729-4254-808d-16e12eec659f".keyFile = "/boot/crypto_keyfile.bin";
  boot.initrd.luks.devices."luks-58655766-776f-42ca-96b1-a87a3e21508f".keyFile = "/boot/crypto_keyfile.bin";
  networking.hostName = "halley";
  networking.wireless.enable = false;
  networking.networkmanager.enable = true;
  time.timeZone = "Europe/London";
  i18n.defaultLocale = "en_GB.UTF-8";
  console.keyMap = "uk";

  users.users.cdo = {
    uid = 1000;
    isNormalUser = true;
    description = "Christina O'Donnell";
    extraGroups = [ "networkmanager" "wheel" ];
  };

  home-manager = {
    users.cdo = import ../../home/client.nix;
  };
}
