(use-modules (gnu))

(use-service-modules networking)
(use-package-modules bootloaders)

(define %keyboard-layout
  (keyboard-layout "gb"))

(operating-system
  (locale "en_GB.utf8")
  (timezone "Etc/UTC")
  (keyboard-layout %keyboard-layout)
  (host-name "test-vm")
  (packages (cons* (specification->package "net-tools")
                   %base-packages))
  (services
   (cons* (service dhcp-client-service-type)
          %base-services))
  (bootloader
   (bootloader-configuration
    (bootloader grub-bootloader)
    (targets '("/dev/vda"))
    (terminal-outputs '(console))
    (keyboard-layout %keyboard-layout)))
  (file-systems
   (cons* (file-system
           (mount-point "/")
           (device "/dev/vda1")
           (type "ext4"))
          %base-file-systems)))
