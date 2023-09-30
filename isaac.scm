(use-modules
 (gnu)
 (cdo config system-common)
 (nongnu system linux-initrd)
 (nongnu packages linux))

(operating-system
  (kernel linux)
  (kernel-arguments
   (list "crashkernel=256M"))
  (firmware (list linux-firmware))
  (initrd microcode-initrd)

  (locale "en_GB.utf8")
  (timezone "Europe/London")
  (keyboard-layout %keyboard-layout)
  (host-name "isaac")
  (users %user-accounts)
  (groups %user-groups)
  (packages %common-packages)
  (services %common-services)
  (bootloader (bootloader-configuration
               (bootloader grub-efi-bootloader)
               (targets (list "/boot/efi"))
               (menu-entries
                (list (menu-entry
                       (label "Debian")
                       (initrd "/boot/initrd.img-6.4.0-4-amd64")
                       (linux "/boot/vmlinuz-6.4.0-4-amd64")
                       (linux-arguments
                        (list "root=UUID=ec5539cc-5eb5-4a0a-a919-1de9fec3f248"))
                       (device "1b40ff94-038e-994f-a7d2-f14e1c01dde4"))))
               (keyboard-layout keyboard-layout)))
  (mapped-devices
    (list (mapped-device
	    (source (uuid "a7378653-dea4-48dc-a8c8-b65e31745dd3"))
	    (target "home")
	    (type luks-device-mapping))))
  (file-systems (cons* (file-system
			(device (file-system-label "home"))
                        (mount-point "/home")
                        (type "ext4")
			(dependencies mapped-devices))
                       (file-system
                        (mount-point "/")
                        (device (uuid
                                 "82cdad44-17f3-4d55-a547-cb3c8349b3d1"
                                 'ext4))
                        (type "ext4"))
                       (file-system
                        (mount-point "/boot/efi")
                        (device (uuid "92CD-AAF1"
                                      'fat32))
                        (type "vfat")) %base-file-systems))
  (sudoers-file (local-file "/home/cdo/config/sudoers"))
  (hosts-file (local-file "/home/cdo/config/hosts")))

;;/dev/sda5: UUID="a7378653-dea4-48dc-a8c8-b65e31745dd3" TYPE="crypto_LUKS" PARTUUID="5cb2ecde-199f-284b-84d1-dcbba217ad6b"
