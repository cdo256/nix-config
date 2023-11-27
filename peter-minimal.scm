(use-modules
  (gnu)
  (gnu packages shells)
  (gnu packages bash)
  (gnu services desktop)
  (ice-9 match))
(use-service-modules)

(define %keyboard-layout
  (keyboard-layout "gb"))

(define %user-accounts
  (cons* (user-account
          (name "cdo")
          (uid 1000)
          (comment "Christina O'Donnell")
          (group "cdo")
          (home-directory "/home/cdo")
          (supplementary-groups
           '("users" "wheel" "netdev" "audio" "video" ))
          (shell (file-append bash "/bin/bash")))
         %base-user-accounts))

(define %user-groups
  (cons* (user-group
          (name "cdo")
          (id 1000))
         %base-groups))

(define %common-packages
  (append
   (specifications->packages
    (list "nss-certs"
          "python"))
   %base-packages))

(define %common-services %base-services)

(operating-system
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
  (file-systems (cons* (file-system
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
                         (mount-point "/boot/efi")
                         (device (uuid "F184-6370"
                                       'fat32))
                         (type "vfat"))
                       %base-file-systems))
  (sudoers-file (local-file "/home/cdo/config/sudoers"))
  (hosts-file (local-file "/home/cdo/config/hosts")))

