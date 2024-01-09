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
  (groups
   (cons* (user-group
           (name "plugdev")
           (id 30002))
          (user-group
           (name "libvirt")
           (id 30003))
          %user-groups))
  (packages %common-packages)
  (services %base-services)
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
  (file-systems (cons* (file-system
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
