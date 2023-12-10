(use-modules
 (gnu)
 (cdo config system-common)
 (gnu packages linux)
 (nongnu system linux-initrd)
 (nongnu packages linux))

(operating-system
  (kernel linux)
  (kernel-arguments
   (list "crashkernel=256M"))
  (kernel-loadable-modules
   (list v4l2loopback-linux-module))
  (firmware (list linux-firmware))
  (initrd microcode-initrd)

  (locale "en_GB.utf8")
  (timezone "Europe/London")
  (keyboard-layout %keyboard-layout)
  (host-name "peter")
  (users %user-accounts)
  (groups %user-groups)
  (packages %common-packages)
  (services %common-services)
  (bootloader
    (bootloader-configuration
      (bootloader grub-efi-bootloader)
      (targets (list "/boot/efi"))
      (menu-entries
       (list (menu-entry
              (label "Debian")
              (initrd "/boot/initrd.img-5.10.0-23-amd64")
              (linux "/boot/vmlinuz-5.10.0-23-amd64")
              (linux-arguments
               (list "root=UUID=3214fc2c-d68a-4a5e-8c95-71a1dc6c57a0"))
              (device "bc2c94bf-fa93-4754-b655-ade0ff03816b"))))
      (keyboard-layout %keyboard-layout)))
  (swap-devices
    (list (swap-space
            (target
	     (uuid "fdfc8239-e381-4286-b010-ee9c9411e823")
             ;; (uuid "d05290b8-8439-413a-9f3a-323b91db8fdd")
	     ))))
  (file-systems (cons* ;; (file-system
                       ;;   (mount-point "/mnt/3")
                       ;;   (device (uuid
                       ;;            "a2f6e327-1e37-4e1a-a238-478fc46fbbf2"
                       ;;            'ext4))
                       ;;   (type "ext4"))
                       (file-system
                         (mount-point "/home")
                         (device (uuid
                                  "12e48f4c-68b0-4819-a122-989eb034f1f2"
                                  'ext4))
                         (type "ext4"))
                       (file-system
                         (mount-point "/")
                         (device (uuid
                                  "0d523c86-12d0-4658-832f-f619756199c1"
                                  'ext4))
                         (type "ext4"))
                       (file-system
                         (mount-point "/mnt/9")
                         (device (uuid
                                  "db250592-fef3-4b4d-a1e2-3d31167a0037"
                                  'ext4))
                         (type "ext4"))
                       (file-system
                         (mount-point "/boot/efi")
                         (device (uuid "F184-6370"
                                       'fat32))
                         (type "vfat"))
                       %base-file-systems))
  (sudoers-file (local-file "/home/cdo/config/sudoers"))
  (hosts-file (local-file "/home/cdo/config/hosts")))

