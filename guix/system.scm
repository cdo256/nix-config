(use-modules
  (gnu)
  (gnu packages shells)
  (gnu services sound)
  (gnu services security-token)
  (gnu services syncthing)
  (gnu services mcron)
  (gnu packages linux)
  (gnu packages emacs)
  (gnu packages admin)
  (nongnu system linux-initrd)
  (nongnu packages linux))
(use-service-modules
  cups
  desktop
  networking
  ssh
  xorg
  sddm)

(define %yubikey-gpg-udev-rule
 (udev-rule
   "90-yubikey.rules"
   (string-append
    "ACTION==\"bind\", ENV{DEVTYPE}==\"usb_device\", "
    "ENV{SUBSYSTEM}==\"usb\", ENV{PRODUCT}==\"1050/*\", "
    "RUN+=\"/bin/sh -c '/run/setuid-programs/sudo -u cdo "
      "/home/cdo/.guix-profile/bin/gpg-connect-agent --homedir=/home/cdo/.local/secure/gnupg/ \\\"scd serialno\\\" \\\"learn --force\\\" /bye "
      "2>&1 >>/var/log/gpg-connect-agent.log'\"\n")))

(define (mutate-pam-entry entry)
 (if (string=? "pam_env.so" (pam-entry-module entry))
     (pam-entry
      (control (pam-entry-control entry))
      (module (pam-entry-module entry))
      (arguments (cons "user_readenv=1"
                       (pam-entry-arguments entry))))
     entry))

(define* (cdo-backup-filename machine-name backup-part #:optional  (file-system "/mnt/9") (date (current-date)))
  (date-stamp (format #f "~4,'0d~2,'0d~2,'0d"
                      (date-year date)
                      (date-month date)
                      (date-day date)))
  (format #f "~s/backup/~s-~s-~s.tar.gz"
          file-system date-stamp machine-name backup-part))

(define cdo-mcron-jobs
  '(
    (job '(next-hour '(2))
         '((let ((backup-file (cdo-backup-filename "peter" "root")))
             (spawn "tar" "-cazf" backup-file
                    "--one-file-system"
                    "-C" "/" "/"))))

    (job '(next-hour '(2))
         '((let ((backup-file (cdo-backup-filename "isaac" "root"))
                 (remote-cmd '("tar" "-cazf" "-"
                               "--one-file-system"
                               "-C" "/" "/")))
             (apply spawn (concat '("ssh" "cdo@isaac") remote-cmd)
                    #:output (open-file local-output-file "w")))))
    (job '(next-hour '(5))
         '((spawn "rsync" "-Pa" "/mnt/9/" "/mnt/3/"))
         '((spawn "rsync" "-Pa" "/mnt/9/" "cdo@william:/srv/files/cdo/")))))


(operating-system
  (kernel linux)
  ;; (kernel-arguments (list "module_blacklist=nouveau"
                          ;; "nvidia_drm.modeset=1"))
  ;; (kernel-arguments (list "crashkernel=256M"))
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
                    '("wheel" "netdev" "audio" "video" "backup"))
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
            (specification->package "emacs-exwm")
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
            (service sddm-service-type
              (sddm-configuration
                (display-server "x11")
                (xorg-configuration (xorg-configuration
                  (keyboard-layout keyboard-layout)))))
            (service alsa-service-type)
            (service pcscd-service-type)
            ;; (service mcron-service-type
            ;;          (mcron-configuration
            ;;           (jobs cdo-mcron-jobs)))
            (service syncthing-service-type
              (syncthing-configuration
               (user "cdo")
               (logflags 19) ;; date,time,ms,long-filename,short-filename
               (arguments '("--logfile"
                            "/var/log/syncthing-cdo.log"))))
            (udev-rules-service 'yubikey-gpg %yubikey-gpg-udev-rule))
      (modify-services %base-services
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
  (hosts-file (local-file "/home/cdo/.config/hosts"))
  (pam-services 
   (map (lambda (s)
    (pam-service
      (name (pam-service-name s))
      (account (pam-service-account s))
      (auth (pam-service-auth s))
      (password (pam-service-password s))
      (session (map mutate-pam-entry (pam-service-session s)))))
    (base-pam-services))))

