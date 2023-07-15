(use-modules
  (gnu)
  (gnu packages admin)
  (gnu packages emacs)
  (gnu packages linux)
  (gnu packages security-token)
  (gnu packages shells)
  (gnu packages virtualization)
  (gnu services desktop)
  (gnu services docker)
  (gnu services mcron)
  (gnu services shepherd)
  (gnu services sound)
  (gnu services security-token)
  (gnu services syncthing)
  (gnu services virtualization)
  (nongnu system linux-initrd)
  (nongnu packages linux)
  (ice-9 match))
(use-service-modules
  cups
  desktop
  networking
  ssh
  xorg
  sddm)

(define (string-escape-just-quotes string)
  (call-with-output-string
    (lambda (p)
      (string-for-each (lambda (c)
                         (case c
                           ((#\")
                            (write-char #\\ p)
                            (write-char c p))
                           (else
                            (write-char c p))))
                       string))))

(define (udev-clause->string clause)
  (match clause
    ((attribute operator value)
     (string-append attribute
                    (symbol->string operator)
                    "\""
                    (string-escape-just-quotes value)
                    "\""))))

(define (udev-rule->string udev-rule)
  (string-join (map udev-clause->string udev-rule) ", "))

(define (udev-rules->string udev-rules)
  (string-append (string-join (map udev-rule->string udev-rules) "\n") "\n"))

(define %yubikey-udev-rules
  (udev-rule
    "90-yubikey.rules"
    (udev-rules->string
     `((("ACTION" == "add")
        ("SUBSYSTEM" == "usb")
        ("ATTRS{idVendor}" == "1050")
        ("MODE" = "0664")
        ("GROUP" = "plugdev"))
       (("ACTION" == "bind")
        ("ENV{DEVTYPE}" == "usb_device")
        ("ENV{SUBSYSTEM}" == "usb")
        ("ENV{PRODUCT}" == "1050/*")
        ("RUN" += "/run/setuid-programs/sudo -iu cdo on-yubikey-insert"))
       (("ACTION" == "remove")
        ("ENV{DEVTYPE}" == "usb_device")
        ("ENV{SUBSYSTEM}" == "usb")
        ("ENV{PRODUCT}" == "1050/*")
        ("RUN" += "/run/setuid-programs/sudo -iu cdo on-yubikey-remove"))))))

(operating-system
  (kernel linux)
  (kernel-arguments
   (list ;; "module_blacklist=nouveau"
         ;; "nvidia_drm.modeset=1"
         "crashkernel=256"))
  (firmware (list linux-firmware))
  ;; Should include radeon-firmware
  (initrd microcode-initrd)

  (locale "en_GB.utf8")
  (timezone "Europe/London")
  (keyboard-layout (keyboard-layout "gb"))
  (host-name "peter")
  (users (cons* (user-account
                  (name "cdo")
                  (comment "Christina O'Donnell")
                  (group "users")
                  (home-directory "/home/cdo")
                  (supplementary-groups
                    '("wheel" "netdev" "audio" "video" "backup" "plugdev" "libvirt"))
                  (shell (file-append fish "/bin/fish")))
                (user-account
                  (name "backup")
                  (group "backup")
                  (shell (file-append shadow "/sbin/nologin"))
                  (system? #t))
                %base-user-accounts))
  (groups (cons* (user-group
                  (name "backup"))
                 %base-groups))
  (packages
    (append
      (list (specification->package "nss-certs")
            (specification->package "fish")
            (specification->package "sway")
            (specification->package "python")
            (specification->package "yubico-pam")
            (specification->package "linux-pam")
            (specification->package "virt-manager"))
      %base-packages))
  (services
    (append
      (list (service openssh-service-type)
            (service gpm-service-type)
            (service docker-service-type)
            (service sddm-service-type
              (sddm-configuration
                (display-server "wayland")
                (xorg-configuration (xorg-configuration
                  (keyboard-layout keyboard-layout)))))
            (service pcscd-service-type)
            (service libvirt-service-type
              (libvirt-configuration
               (auth-unix-ro "none")
               (auth-unix-rw "none")
               (unix-sock-group "libvirt")))
            (service virtlog-service-type)
            ;; (service mcron-service-type
            ;;          (mcron-configuration
            ;;           (jobs cdo-mcron-jobs)))
            (udev-rules-service 'u2f libfido2 #:groups '("plugdev"))
            (service syncthing-service-type
              (syncthing-configuration
               (user "cdo")
               (logflags 19) ;; date,time,ms,long-filename,short-filename
               (arguments '("--logfile"
                            "/var/log/syncthing-cdo.log"))))
            (udev-rules-service 'yubikey %yubikey-udev-rules))
      (modify-services %desktop-services
        (delete gdm-service-type)
        (guix-service-type config => (guix-configuration
         (extra-options '("--cores=8")))))))
  (bootloader
    (bootloader-configuration
      (bootloader grub-efi-bootloader)
      (targets (list "/boot/efi"))
      (keyboard-layout keyboard-layout)))
  (swap-devices
    (list (swap-space
            (target
             (uuid "d05291b8-8439-413a-9f3a-323b91db8fdd")))))
  (file-systems (cons* (file-system
                         (mount-point "/mnt/3")
                         (device (uuid
                                  "a2f6e327-1e37-4e1a-a238-478fc46fbbf2"
                                  'ext4))
                         (type "ext4"))
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
  (sudoers-file (local-file "/home/cdo/.config/sudoers"))
  (hosts-file (local-file "/home/cdo/.config/hosts")))

