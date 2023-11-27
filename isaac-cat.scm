(define-module (cdo config system-common)
  #:export (udev-rules->string
            %keyboard-layout
            %yubikey-udev-rules
            %user-accounts
            %user-groups
            %common-packages
            %common-services))
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
           '("users" "wheel" "netdev" "audio" "video" "backup" "plugdev" "libvirt"))
          (shell (file-append bash "/bin/bash")))
         (user-account
          (name "olivia")
          (comment "Olivia Biid")
          (group "cdo")
          (home-directory "/home/olivia")
          (supplementary-groups
           '("users" "wheel" "netdev" "audio" "video" "backup" "plugdev" "libvirt"))
          (shell (file-append bash "/bin/bash")))
         (user-account
          (name "backup")
          (group "backup")
          (shell (file-append shadow "/sbin/nologin"))
          (system? #t))
         %base-user-accounts))

(define %user-groups
  (cons* (user-group
          (name "cdo")
          (id 1000))
         (user-group
          (name "backup")
          (id 30001))
         %base-groups))

(define %common-packages
  (append
   (specifications->packages
    (list "bluez"
          "bluez-alsa"
          "bluez-qt"
          "bluez-firmware"
          "blueman"
          "fish"
          "kexec-tools"
          "linux-pam"
          "nss-certs"
          "pinentry"
          "pulseaudio"
          "python"
          "sway"
          "virt-manager"
          "yubico-pam"))
   %base-packages))

(define %common-services
    (append
      (list (service openssh-service-type)
            (service gpm-service-type)
            (service docker-service-type)
            (service gnome-desktop-service-type)
            (service bluetooth-service-type
                     (bluetooth-configuration
                      (auto-enable? #t)))
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
