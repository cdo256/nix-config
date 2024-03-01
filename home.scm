(define-module (cdo config home)
  #:use-module (gnu)
  #:use-module (gnu home)
  #:use-module (gnu home services)
  #:use-module (gnu home services shells)
  #:use-module (gnu home services fontutils)
  #:use-module (gnu home services mcron)
  #:use-module (gnu home services desktop)
  #:use-module (gnu home services guix)
  #:use-module (gnu home services xdg)
  #:use-module (gnu home services shepherd)
  #:use-module (gnu packages)
  #:use-module (gnu packages emacs)
  #:use-module (gnu services)
  #:use-module (gnu services shepherd)
  #:use-module (gnu services mcron)
  #:use-module (guix channels)
  #:use-module (guix gexp)
  #:use-module (guix ci)
  #:use-module (guix records)
  #:use-module (ice-9 match))

(define cdo-guix-channels
  (list (channel-with-substitutes-available
         (channel
	        (name 'guix)
	        ; (branch "staging")
	        (url "https://git.savannah.gnu.org/git/guix.git")
	        (introduction (make-channel-introduction
		                     "9a2e8664ecd0b7fe3371cb268506e68037b3263d"
		                     (openpgp-fingerprint
			                    "BBB0 2DDF 2CEA F6A8 0D1D  E643 A2A0 6DF2 A33A 54FA"))))
         "https://ci.guix.gnu.org")
        (channel
	       (name 'nonguix)
	       (url "https://gitlab.com/nonguix/nonguix")
	       (introduction (make-channel-introduction
		                    "897c1a470da759236cc11798f4e0a5f7d4d59fbc"
		                    (openpgp-fingerprint
			                   "2A39 3FFF 68F4 EF7A 3D29  12AF 6F51 20A0 22FB B2D5"))))))

(define cdo-environment-variables
     '(("BROWSER" . "chromium")
       ("TERMINAL" . "alacritty")
       ("EDITOR" . "emacsclient")
       ("GUIX_PROFILE" . "$HOME/.guix-profile")
       ("PATH" . "/home/cdo/scripts:$PATH")
       ;;; Disabled as they're already defined by default
       ;; ("XDG_CACHE_HOME" . "$HOME/.local/cache")
       ;; ("XDG_CONFIG_HOME" . "$HOME/.config")
       ;; ("XDG_DATA_HOME" . "$HOME/.local/data") ;; Default is .local/share
       ;; ("XDG_STATE_HOME" . "$HOME/.local/state")
       ("XDG_DOWNLOAD_DIR" . "$HOME/downloads")
       ("XDG_PICTURES_DIR" . "$HOME/images")
       ("XDG_TEMPLATES_DIR" . "$HOME")
       ("XDG_VIDEOS_DIR" . "$HOME")
       ("XDG_DESKTOP_DIR" . "$HOME")
       ("XDG_DOCUMENTS_DIR" . "$HOME")
       ("XDG_MUSIC_DIR" . "$HOME")

       ("ANSIBLE_HOME" . "$XDG_CONFIG_HOME/ansible")
       ("ANSIBLE_CONFIG" . "$XDG_CONFIG_HOME/ansible")
       ("ANSIBLE_GALAXY_CACHE_DIR" . "$XDG_CACHE_HOME/ansible/galaxy_cache")
       ("BASH_HISTORY" . "$XDG_STATE_HOME/shell/histfile")
       ("BZR_HOME" . "$XDG_CACHE_HOME/bazaar")
       ("BZRPATH" . "$XDG_CONFIG_HOME/bazaar")
       ("BZR_PLUGIN_PATH" . "$XDG_DATA_HOME/bazaar")
       ("CARGO_HOME" . "$XDG_DATA_HOME/cargo")
       ("GNUPGHOME" . "$HOME/.local/secure/gnupg")
       ("GOBIN" . "$HOME/.local/bin")
       ("GOCACHE" . "$XDG_CACHE_HOME/go")
       ("GOMODCACHE" . "$XDG_CACHE_HOME/go/modules")
       ("GOPATH" . "$XDG_CACHE_HOME/go:$HOME/src")
       ;; ("GOROOT" . "$GUIX_PROFILE/lib/go")
       ("GOTMPDIR" . "/tmp")
       ("GOTOOLDIR" . "$XDG_DATA_HOME/go")
       ("GUILE_HISTORY" . "$XDG_STATE_HOME/guile/history")
       ("GUILE_LOAD_PATH" . "$XDG_CONFIG_HOME/guile:$HOME/src/guile:$GUILE_LOAD_PATH")
       ("GUIX_DAEMON_SOCKET" . "guix://localhost:44146")
       ("HISTFILE" . "$XDG_STATE_HOME/shell/histfile")
       ("ICEAUTHORITY" . "$XDG_CACHE_HOME/x11/ICEauthority")
       ("JULIA_DEPOT_PATH" . "$XDG_DATA_HOME/julia:$GUIX_PROFILE/share/julia/")
       ("LESSHISTFILE" . "$XDG_STATE_HOME/less/hist")
       ("LESSKEY" . "$XDG_CONFIG_HOME/less/keys")
       ("MAILDIR" . "$XDG_DATA_HOME/mail/") ;; Trailing slash needed by mu
       ("MPLAYER_HOME" . "$XDG_CONFIG_HOME/mplayer")
       ("PYTHONHISTFILE" . "$XDG_DATA_HOME/python/histfile")
       ("PYTHONSTARTUP" . "$XDG_CONFIG_HOME/python/startup.py")
       ("QT_QPA_PLATFORM_PLUGIN_PATH" . "$GUIX_PROFILE/lib/qt5/plugins")
       ("SPACEMACSDIR" . "$XDG_CONFIG_HOME/spacemacs")
       ("SUBVERSION_HOME" . "$XDG_CONFIG_HOME/subversion")
       ("VIMDOTDIR" . "$XDG_CONFIG_HOME/vim")
       ("XAUTHORITY" . "$XDG_DATA_HOME/x11/xauthority")
       ("XINITRC" . "$XDG_CONFIG_HOME/x11/xinitrc")))

(define-record-type* <emacs-server-configuration>
  emacs-server-configuration make-emacs-server-configuration
  emacs-server-configuration?
  (emacs emacs-server-configuration-emacs
         (default emacs))
  (additional-arguments emacs-server-configuration-additional-arguments
                        (default '())))

(define emacs-service
  (match-lambda
    (($ <emacs-server-configuration> emacs additional-arguments)
     (list (shepherd-service
            (provision (list emacs-server))
            (documentation "Emacs server.")
            (start #~(make-forkexec-constructor
                      (append (list #$emacs "--daemon")
                              additional-arguments)))
            (stop #~(make-kill-destructor))
            (respawn? #t))))))

(define cdo-fontconfig
  (list
   '(alias
     (family "sans-serif")
     (prefer
      (family "Noto Sans")
      (family "Noto Color Emoji")
      (family "Noto Emoji")
      (family "FontAwesome")
      (family "Linux Biolinum") ; from font-linuxlibertine
      (family "Unifont")))
   '(alias
     (family "serif")
     (prefer
      (family "Noto Serif")
      (family "Noto Color Emoji")
      (family "Noto Emoji")
      (family "FontAwesome")
      (family "Linux Libertine") ; from font-linuxlibertine
      (family "Unifont")))
   '(alias
     (family "monospace")
     (prefer
      (family "Noto Sans Mono")
      (family "Noto Color Emoji")
      (family "Noto Emoji")
      (family "FontAwesome")
      (family "Linux Biolinum") ; from font-linuxlibertine
      (family "Unifont")))))

(define %desktop-environment-packages
  '(;; Desktop Environment and Related Packages
    "adwaita-icon-theme" ;; GNOME icon theme
    "font-awesome" ;; Font awesome
    "font-gnu-unifont" ;; Low quality but comprehenisve fonts
    "font-google-noto" ;; Noto fonts
    "font-google-noto-emoji" ;; Noto emoji fonts
    "font-linuxlibertine" ;; "Linux Libertine" and "Linux Biolinum"
    "gnome" ;; The GNU desktop environment
    "gnome-calculator" ;; Desktop calculator
    "grim" ;; Create screenshots in a wayland compositor
    "icedove-wayland" ;; Copyright-less email client
    "matcha-theme" ;; Flat design theme for GTK 3, GTK 2 and GNOME-Shell
    "qtwayland" ;; Qt Wayland module
    "speech-dispatcher" ;; Common interface to speech synthesizers
    "slurp" ;; Select a region in a wayland compositor
    "sway" ;; Wayland compositor compatible with i3
    "xdg-desktop-portal-kde" ;; Backend implementation for xdg-desktop-portal using Qt/KF5
    "xdg-user-dirs" ;; Tool to help manage "well known" user directories
    "xorg-server" ;; Xorg implementation of the X Window System
    "xorg-server-xwayland" ;; Xorg server with Wayland backend
    "wofi" ;; Launcher/menu program for wayland
    "waybar" ;; Wayland bar for Sway and Wlroots based compositors
    "alacritty" ;; Terminal emulator
    "vinagre" ;; Remote desktop viewer
    ))

(define %development-tools
  '(;; Development Tools
    "autoconf" ;; Create source code configuration scripts
    "automake" ;; Making GNU standards-compliant Makefiles
    "clang" ;; C language family frontend for LLVM
    "gcc-toolchain" ;; Complete GCC tool chain for C/C++ development
    "git" ;; Distributed version control system
    "git:send-email" ;; Send emails with Git
    "libtool" ;; Generic shared library support tools
    "make" ;; Remake files automatically
    "pkg-config" ;; Helper tool used when compiling applications and libraries
    "python" ;; High-level, dynamically-typed programming language
    "python-pip" ;; Package manager for Python software
    "python-pyopencl" ;; Python wrapper for OpenCL
    "rocm-comgr" ;; ROCm Compiler Driver
    "rocm-device-libs" ;; ROCm Device Libraries
    "rocr-runtime" ;; ROCm Runtime
    "rust-cargo" ;; Package manager for Rust
    ))

(define %system-utilities
  '(;; System Utilities and Libraries
    "basu" ;; The sd-bus library, extracted from systemd
    "bridge-utils" ;; Manipulate Ethernet bridges
    "ccid" ;; PC/SC driver for USB smart card devices
    "cloc" ;; Count source lines of code (SLOC) and other source code metrics
    "cmatrix" ;; Simulate the display from "The Matrix"
    "coreutils" ;; Core GNU utilities (file, text, shell)
    "cryptsetup" ;; Set up transparent encryption of block devices using dm-crypt
    "dbus" ;; Message bus for inter-process communication (IPC)
    "ddrescue" ;; Data recovery utility
    "diffutils" ;; Comparing and merging files
    "file" ;; File type guesser
    ;; Note this shadows the more up to date .config/guix/current!
    ;; "guix" ;; Include guix iteself!
    "isync" ;; Mailbox sync utility for use with mu4e
    "libcap" ;; Library for working with POSIX capabilities
    "libfido2" ;; Library functionality and command-line tools for FIDO devices
    "libiconv" ;; Character set conversion library
    "linux-pam" ;; Pluggable authentication modules for Linux
    "lm-sensors" ;; Utilities to read temperature/voltage/fan sensors
    "lsof" ;; Display information about open files
    "moreutils" ;; Miscellaneous general-purpose command-line tools
    "mu" ;; Mail syncing agent
    "neofetch" ;; System information script
    "pam-u2f" ;; PAM module for U2F authentication
    "pamixer" ;; PulseAudio command line mixer
    "pulseaudio-qt" ;; Qt bindings for PulseAudio
    "pv" ;; Progress monitor
    "recutils" ;; Manipulate plain text files as databases
    "sendmail" ;; Highly configurable Mail Transfer Agent (MTA)
    "socat" ;; Open bidirectional communication channels from the command line
    "spice-gtk" ;; SPICE client
    "sqlitebrowser" ;; Visual database browser and editor for SQLite
    "strace" ;; System call tracer for Linux
    "synergy" ;; Mouse and keyboard sharing utility
    "v4l-utils" ;; Realtime video capture utilities for Linux
    "xhost" ;; Xorg server access control utility
    "xinit" ;; Commands to start the X Window server
    "xkbutils" ;; XKB utilities
    "zoom" ;; Zoom video conferencing software
    ))


(define %multimedia-graphics-tools
  '(;; Multimedia and Graphics Tools
    "ffmpeg" ;; Audio and video framework
    "gimp" ;; GNU Image Manipulation Program
    "mediainfo" ;; Utility for reading media metadata
    "obs" ;; Live streaming software
    "okular" ;; Document viewer
    "vlc" ;; Audio and video framework
    "mpv" ;; Audio and video player
    "inkscape" ;; Vector graphics editor
    "guvcview" ;; GTK+ UVC Viewer
    "nomacs" ;; Image viewer and manipulator
    ))

(define %text-editors-packages
  '(;; Text Editors and Related Packages
    "emacs-all-the-icons" ;; Collect icon fonts and propertize them within Emacs
    ;; For when it becomes available!
    ;; "emacs-combobulate" ;; Structual editing in Emacs
    "emacs-counsel" ;; Various completion functions using Ivy
    "emacs-counsel-tramp" ;; Ivy interface for TRAMP
    "emacs-debbugs" ;; Access the Debbugs bug tracker in Emacs
    "emacs-exwm" ;; Emacs X window manager
    "emacs-git-email" ;; Format and send Git patches in Emacs
    "emacs-guix" ;; Emacs interface for GNU Guix
    "emacs-ivy" ;; Incremental vertical completion for Emacs
    "emacs-jupyter" ;; Emacs interface to communicate with Jupyter kernels
    "emacs-ox-hugo" ;; Org-mode to Hugo exporter
    "emacs-paredit" ;; Emacs minor mode for editing parentheses
    "emacs-pgtk" ;; Emacs text editor with `pgtk' frames
    "emacs-smartparens" ;; Paredit-like insertion, wrapping and navigation with user defined pairs
    "emacs-trashed" ;; View and edit system trash can in Emacs
    "vim" ;; Text editor based on vi
    "vscodium" ;; Free text editor based off VSCode
    ))

(define %package-management-utilities
  '(;; Package Management and Utilities
    "dpkg" ;; Debian package management system
    "guile" ;; Scheme implementation intended especially for extensions
    "guile-colorized" ;; Colorized REPL for Guile
    "guile-gcrypt" ;; Cryptography library for Guile using Libgcrypt
    "guile-readline" ;; Line editing support for GNU Guile
    "pkg-config" ;; Helper tool used when compiling applications and libraries
    ))

(define %web-browsers
  '(;; Web Browsers
    "firefox-esr" ;; Trademarkless version of Firefox
    "ungoogled-chromium-wayland" ;; Graphical web browser
    "ublock-origin-chromium" ;; Block unwanted content from web sites
    ))

(define %security-authentication-tools
  '(;; Security and Authentication Tools
    "gnupg" ;; GNU Privacy Guard
    "libyubikey" ;; Development kit for the YubiKey authentication device
    "pcsc-lite" ;; Middleware to access a smart card using PC/SC
    "pcsc-tools" ;; Smart cards and PC/SC tools
    "pinentry" ;; GnuPG's interface to passphrase input
    "pinentry-qt" ;; GnuPG's interface to passphrase input
    "yubico-pam" ;; Yubico pluggable authentication module
    ))

(define %office-document-tools
  '(;; Office and Document Tools
    "libreoffice" ;; Office suite
    "texinfo" ;; The GNU documentation format
    "keepassxc" ;; Password manager (Added category packages)
    ))

(define %system-monitoring-tools
  '(;; Monitoring and Performance Tools
    "glances" ;; Cross-platform curses-based monitoring tool
    "htop" ;; Interactive process viewer
    "iotop" ;; Interactive `top'-like input/output activity monitor
    "libvirt" ;; Simple API for virtualization
    "nmon" ;; Monitor system performance in a terminal or to a `.csv' log file
    "radeontop" ;; Monitor Radeon graphics cards
    ))

(define %file-disk-management-tools
  '(;; File and Disk Management Tools
    "direnv" ;; Per-directory environments
    "gparted" ;; Partition editor to graphically manage disk partitions
    "gptfdisk" ;; Low-level GPT disk partitioning and formatting
    "po4a" ;; Tools for using PO files
    "rsync" ;; Remote (and local) file copying tool
    "trash-cli" ;; Trash can management tool
    "tree" ;; Recursively list the contents of a directory
    "unzip" ;; Decompression and file extraction utility
    "zip" ;; Compression and file packing utility
    ))

(define %scientific-technical-computing
  '(;; Scientific and Technical Computing
    "julia" ;; High-performance dynamic language for technical computing
    "jupyter" ;; Web application for interactive documents
    "kicad" ;; Electronic design automation suite
    "kicad-doc" ;; Documentation for KiCad
    ))

(define %printers-hardware-tools
  '(;; Printers and Hardware Tools
    "dmidecode" ;; Read hardware information from the BIOS
    "hplip" ;; HP printer drivers
    "libwacom" ;; Helper library for graphics tablet settings
    "net-tools" ;; Tools for controlling the network subsystem in Linux
    "wacomtablet" ;; KDE GUI for the Wacom Linux Drivers
    ))

(define %cdo-packages
  ;; My default list of packages
  (append %desktop-environment-packages
          %development-tools
          %system-utilities
          %multimedia-graphics-tools
          %text-editors-packages
          %package-management-utilities
          %web-browsers
          %security-authentication-tools
          %office-document-tools
          %system-monitoring-tools
          %file-disk-management-tools
          %scientific-technical-computing
          %printers-hardware-tools))

(define cdo-home-environment
  (home-environment
   (packages (specifications->packages %cdo-packages))
   (services
    (list
     (simple-service 'cdo-home-fontconfig
                     home-fontconfig-service-type
                     cdo-fontconfig)
     (simple-service 'cdo-environment-variables
                     home-environment-variables-service-type
                     cdo-environment-variables)
     (service home-bash-service-type
              (home-bash-configuration
               (environment-variables cdo-environment-variables)
               (guix-defaults? #t)))
     (service home-fish-service-type
              (home-fish-configuration
               (environment-variables cdo-environment-variables)
               (aliases '())
               (config (list (local-file
                              "/home/cdo/config/fish/config.fish"
                              "config.fish")))))
     (service home-files-service-type
              `((".mbsyncrc" ,(local-file "./mbsyncrc"))
                ;; ensure these directories exists
                (".local/share/mail/.ensure" ,(plain-file "ensure" ""))
                (".local/share/sway/.ensure" ,(plain-file "ensure" "")) ;; required for wofi output
                ))
     (service home-xdg-configuration-files-service-type
              `(("fish/fish_variables" ,(local-file "./fish/fish_variables"))
                ;; ("fontconfig" ,(local-file "./fontconfig" #:recursive? #t))
                ("gh" ,(local-file "./gh" #:recursive? #t))
                ("git" ,(local-file "./git" #:recursive? #t))
                (".guile" ,(local-file "./guile/init.scm" #:recursive? #t))
                ("hexchat" ,(local-file "./hexchat" #:recursive? #t))
                ("shell" ,(local-file "./shell" #:recursive? #t))
                ("spacemacs/init.el" ,(local-file "./spacemacs/init.el"))
                ("sway" ,(local-file "./sway" #:recursive? #t))
                ("swaylock/config" ,(local-file "./swaylock/config"))
                ("user-dirs.dirs" ,(local-file "./user-dirs.dirs"))
                ("waybar" ,(local-file "./waybar" #:recursive? #t))
                ("wofi" ,(local-file "./wofi" #:recursive? #t))))

     (service home-x11-service-type)
     (service home-channels-service-type
              cdo-guix-channels)
     ;;; disabled. currently failing on my machine
     ;;(service home-redshift-service-type
     ;;         (home-redshift-configuration
     ;;          (location-provider 'manual)
     ;;          (latitude 51.5)
     ;;          (longitude -0.1)))
     ))))

cdo-home-environment
