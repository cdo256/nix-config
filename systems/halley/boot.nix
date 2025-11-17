{ config, lib, ... }:
let
  inherit (lib) mkIf;
in
{
  config.boot = {
    loader.grub = {
      enable = true;
      efiSupport = true;
      device = "nodev";
      #useOSProber = true;
      enableCryptodisk = true;
    };
    loader.efi.efiSysMountPoint = "/boot";
    initrd = {
      luks.devices = {
        "root" = {
          keyFile = "/etc/secrets/crypto_keyfile.bin";
        };
        "swap" = {
          keyFile = "/etc/secrets/crypto_keyfile.bin";
          device = "/dev/disk/by-uuid/1bf70d4e-1e23-4357-b51f-40c34ae2d263";
        };
      };
      # Setup keyfile
      # Delete this to build a VM.
      secrets = {
        "/etc/secrets/crypto_keyfile.bin" = null;
      };
    };
  };
}
#/dev/nvme0n1p1: UUID="26f30444-e729-4254-808d-16e12eec659f" TYPE="crypto_LUKS" PARTUUID="857151df-01"
#/dev/nvme0n1p2: UUID="1bf70d4e-1e23-4357-b51f-40c34ae2d263" TYPE="crypto_LUKS" PARTUUID="857151df-02"
#/dev/nvme0n1p3: UUID="DEC1-0E50" BLOCK_SIZE="512" TYPE="vfat" PARTUUID="857151df-03"
