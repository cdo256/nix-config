{ config, lib, ... }:
let
  inherit (lib) mkIf;
in
{
  config.boot = {
    loader.grub = {
      enable = true;
      device = "/dev/nvme0n1";
      useOSProber = true;
      enableCryptodisk = true;
    };
    initrd = {
      luks.devices = {
        "luks-26f30444-e729-4254-808d-16e12eec659f" = {
          keyFile = "/boot/crypto_keyfile.bin";
        };
        "luks-58655766-776f-42ca-96b1-a87a3e21508f" = {
          keyFile = "/boot/crypto_keyfile.bin";
          device = "/dev/disk/by-uuid/58655766-776f-42ca-96b1-a87a3e21508f";
        };
      };
      # Setup keyfile
      # Delete this to build a VM.
      secrets = {
        "/boot/crypto_keyfile.bin" = null;
      };
    };
  };
}
