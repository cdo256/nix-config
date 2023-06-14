(use-modules
  (gnu)
  (gnu packages shells)
  (gnu services sound)
  (gnu services security-token)
  (gnu services syncthing)
  (gnu packages linux))
;  (nongnu system linux-initrd)
;  (nongnu packages linux))
(use-service-modules
  cups
  desktop
  networking
  ssh
  xorg)
;  sddm)

(define %yubikey-gpg-udev-rule
 (udev-rule
   "90-yubikey.rules"
   (string-append
    "ACTION==\"bind\", ENV{DEVTYPE}==\"usb_device\", "
    "ENV{SUBSYSTEM}==\"usb\", ENV{PRODUCT}==\"1050/*\", "
    "RUN+=\"/bin/sh -c '/run/setuid-programs/sudo -u cdo "
      "/home/cdo/.guix-profile/bin/gpg-connect-agent --homedir=/home/cdo/.gnupg/ \\\"scd serialno\\\" \\\"learn --force\\\" /bye "
      "2>&1 >>/var/log/gpg-connect-agent.log'\"\n")))

(operating-system
;  (kernel linux)
;  (kernel-arguments (list "module_blacklist=nouveau"
;                          "nvidia_drm.modeset=1"))
;  (firmware (list linux-firmware))
  ;; Should include radeon-firmware
;  (initrd microcode-initrd)
;  (kernel-loadable-modules
;    (list ))

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
                    '("wheel" "netdev" "audio" "video"))
                  (shell (file-append fish "/bin/fish")))
                %base-user-accounts))
  (packages
    (append
      (list (specification->package "nss-certs")
            (specification->package "fish")
;            (specification->package "lightdm-gtk-greeter")
            (specification->package "sway")
            (specification->package "linux-pam"))
      %base-packages))
  (services
    (append
      (list (service openssh-service-type)
            (service network-manager-service-type)
            (service wpa-supplicant-service-type)
            (service ntp-service-type)
            (service gpm-service-type)
            (service elogind-service-type)
;            (service sddm-service-type
;              (sddm-configuration
;                (display-server "wayland")
;                (xorg-configuration (xorg-configuration
;                  (keyboard-layout keyboard-layout)))))
            (service alsa-service-type)
            (service pcscd-service-type)
            (service syncthing-service-type
              (syncthing-configuration
               (user "cdo")
               (arguments '("--logfile"
                            "/var/log/syncthing.log"))))
            (udev-rules-service 'yubikey-gpg %yubikey-gpg-udev-rule))
      %base-services))
  (bootloader
    (bootloader-configuration
      (bootloader grub-efi-bootloader)
      (targets (list "/boot/efi"))
      (keyboard-layout keyboard-layout)))
  (swap-devices
    (list (swap-space
            (target
              (uuid "4336fda7-3333-459d-8948-f38ac25f50aa")

              ;(uuid "d05291b8-8439-413a-9f3a-323b91db8fdd")
               ))))
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
  (hosts-file (local-file "/home/cdo/.config/hosts"))
  (pam-services (base-pam-services)))
