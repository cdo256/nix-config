{
  boot.loader = {
    grub.enable = true;
    grub.forceInstall = true;
    grub.device = "nodev";
    timeout = 10; # Allow time for LISH to connect.
  };
}

