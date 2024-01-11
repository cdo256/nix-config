(define-module (cdo config system-common)
  #:export (udev-rules->string
            %keyboard-layout
            %yubikey-udev-rules
            %user-accounts
            %user-groups
            %common-packages
            %common-services)
  #:use-module (gnu)
  #:use-module (gnu packages admin)
  #:use-module (gnu packages emacs)
  #:use-module (gnu packages linux)
  #:use-module (gnu packages security-token)
  #:use-module (gnu packages shells)
  #:use-module (gnu packages bash)
  #:use-module (gnu packages virtualization)
  #:use-module (gnu services cups)
  #:use-module (gnu services desktop)
  #:use-module (gnu services docker)
  #:use-module (gnu services mcron)
  #:use-module (gnu services networking)
  #:use-module (gnu services shepherd)
  #:use-module (gnu services sound)
  #:use-module (gnu services security-token)
  #:use-module (gnu services ssh)
  #:use-module (gnu services syncthing)
  #:use-module (gnu services virtualization)
  #:use-module (gnu services xorg)
  #:use-module (nongnu packages linux)
  #:use-module (nongnu system linux-initrd) 
  #:use-module (ice-9 match))

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
        ("RUN" += "/run/setuid-programs/sudo -iu cdo /home/cdo/scripts/on-yubikey-insert"))
       (("ACTION" == "remove")
        ("ENV{DEVTYPE}" == "usb_device")
        ("ENV{SUBSYSTEM}" == "usb")
        ("ENV{PRODUCT}" == "1050/*")
        ("RUN" += "/run/setuid-programs/sudo -iu cdo /home/cdo/scripts/on-yubikey-remove"))))))

(define %keyboard-layout
  (keyboard-layout "gb"))

(define %user-accounts
  (cons* (user-account
          (name "cdo")
          (comment "Christina O'Donnell")
          (group "users")
          (home-directory "/home/cdo")
          (supplementary-groups
           '("users" "wheel" "netdev" "audio" "video" "backup" "plugdev" "libvirt"))
          (shell (file-append fish "/bin/fish")))
         (user-account
          (name "backup")
          (group "backup")
          (shell (file-append shadow "/sbin/nologin"))
          (system? #t))
         %base-user-accounts))

(define %user-groups
  (cons* (user-group
          (name "backup"))
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
          "v4l2loopback-linux-module"
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
        (gdm-service-type config =>
	        (gdm-configuration
	         (inherit config)
	         (wayland? #t)))
        (guix-service-type config =>
	                         (guix-configuration
	                          (inherit config)
                            (extra-options '("--cores=8"
                                             "--listen=/var/guix/daemon-socket/socket"
                                             "--listen=localhost:44146")))))))
