(use-modules (gnu)
             (gnu home)
             (gnu home services)
             (gnu home services shells)
             (gnu home services fontutils)
             (gnu home services mcron)
             (gnu home services desktop)
             (gnu home services guix)
             (gnu packages)
             (gnu packages emacs)
             (gnu services)
             (gnu services shepherd)
             (gnu services mcron)
             (guix channels)
             (guix gexp)
             (guix ci)
             (guix records)
             (ice-9 match))

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
       ;; ("XDG_CACHE_HOME" . "$HOME/.local/cache")
       ;; ("XDG_CONFIG_HOME" . "$HOME/.config")
       ;; ("XDG_DATA_HOME" . "$HOME/.local/data")
       ("XDG_DOWNLOAD_DIR" . "$HOME/downloads")
       ("XDG_PICTURES_DIR" . "$HOME/images")
       ;; ("XDG_STATE_HOME" . "$HOME/.local/state")
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
       ("GOROOT" . "$GUIX_PROFILE/lib/go")
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
       ("MPLAYER_HOME" . "$XDG_CONFIG_HOME/mplayer")
       ("PATH" . "/home/cdo/scripts:$PATH")
       ("PYTHONHISTFILE" . "$XDG_DATA_HOME/python/histfile")
       ("PYTHONSTARTUP" . "$XDG_CONFIG_HOME/python/startup.py")
       ("QT_QPA_PLATFORM_PLUGIN_PATH" . "$GUIX_PROFILE/lib/qt5/plugins")
       ("SPACEMACSDIR" . "$XDG_CONFIG_HOME/spacemacs")
       ("SUBVERSION_HOME" . "$XDG_CONFIG_HOME/subversion")
       ("VIMDOTDIR" . "$XDG_CONFIG_HOME/vim")
       ("XAUTHORITY" . "$XDG_DATA_HOME/x11/xauthority")
       ("XINITRC" . "$XDG_CONFIG_HOME/x11/xinitrc")))

(define cdo-font-config
  "<?xml version=\"1.0\"?>
<!DOCTYPE fontconfig SYSTEM \"fonts.dtd\">
<fontconfig>
	<alias>
		<family>sans-serif</family>
		<prefer>
			<family>Noto Sans</family>
			<family>Noto Color Emoji</family>
			<family>Noto Emoji</family>
			<family>FontAwesome</family>
			<family>Unifont</family>
		</prefer>
	</alias>
	<alias>
		<family>serif</family>
		<prefer>
			<family>Noto Serif</family>
			<family>Noto Color Emoji</family>
			<family>Noto Emoji</family>
			<family>FontAwesome</family>
			<family>Unifont</family>
		</prefer>
	</alias>
	<alias>
		<family>monospace</family>
		<prefer>
			<family>Noto Mono</family>
			<family>Noto Color Emoji</family>
			<family>Noto Emoji</family>
			<family>FontAwesome</family>
			<family>Unifont</family>
		</prefer>
	</alias>
</fontconfig>
")

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

(define %desktop-environment-packages
  ;; Desktop Environment and Related Packages
  '("adwaita-icon-theme" ;; GNOME icon theme
    "gnome" ;; The GNU desktop environment
    "gnome-calculator" ;; Desktop calculator
    "icedove-wayland" ;; Copyright-less email client
    "matcha-theme" ;; Flat design theme for GTK 3, GTK 2 and GNOME-Shell
    "qtwayland" ;; Qt Wayland module
    "speech-dispatcher" ;; Common interface to speech synthesizers
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
  ;; Development Tools
  '("autoconf" ;; Create source code configuration scripts
    "automake" ;; Making GNU standards-compliant Makefiles
    "clang" ;; C language family frontend for LLVM
    "gcc-toolchain" ;; Complete GCC tool chain for C/C++ development
    "git" ;; Distributed version control system
    "git:sendmail" ;; Send emails with Git
    "libtool" ;; Generic shared library support tools
    "make" ;; Remake files automatically
    "pkg-config" ;; Helper tool used when compiling applications and libraries
    "python" ;; High-level, dynamically-typed programming language
    "python-pip" ;; Package manager for Python software
    "python-pyopencl" ;; Python wrapper for OpenCL
    "rust-cargo" ;; Package manager for Rust
    "emacs-ox-hugo" ;; Org-mode to Hugo exporter
    ))

(define %system-utilities
  ;; System Utilities and Libraries
  '("basu" ;; The sd-bus library, extracted from systemd
    "bridge-utils" ;; Manipulate Ethernet bridges
    "ccid" ;; PC/SC driver for USB smart card devices
    "coreutils" ;; Core GNU utilities (file, text, shell)
    "cryptsetup" ;; Set up transparent encryption of block devices using dm-crypt
    "dbus" ;; Message bus for inter-process communication (IPC)
    "ddrescue" ;; Data recovery utility
    "diffutils" ;; Comparing and merging files
    "file" ;; File type guesser
    "isync" ;; Mailbox sync utility for use with mu4e
    "libcap" ;; Library for working with POSIX capabilities
    "libfido2" ;; Library functionality and command-line tools for FIDO devices
    "libiconv" ;; Character set conversion library
    "linux-pam" ;; Pluggable authentication modules for Linux
    "lm-sensors" ;; Utilities to read temperature/voltage/fan sensors
    "lsof" ;; Display information about open files
    "pamixer" ;; PulseAudio command line mixer
    "pam-u2f" ;; PAM module for U2F authentication
    "pulseaudio-qt" ;; Qt bindings for PulseAudio
    "strace" ;; System call tracer for Linux
    ))

(define %multimedia-graphics-tools
  ;; Multimedia and Graphics Tools
  '("ffmpeg" ;; Audio and video framework
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
  ;; Text Editors and Related Packages
  '("emacs-all-the-icons" ;; Collect icon fonts and propertize them within Emacs
    "emacs-counsel" ;; Various completion functions using Ivy
    "emacs-counsel-tramp" ;; Ivy interface for TRAMP
    "emacs-debbugs" ;; Access the Debbugs bug tracker in Emacs
    "emacs-exwm" ;; Emacs X window manager
    "emacs-git-email" ;; Format and send Git patches in Emacs
    "emacs-guix" ;; Emacs interface for GNU Guix
    "emacs-ivy" ;; Incremental vertical completion for Emacs
    "emacs-jupyter" ;; Emacs interface to communicate with Jupyter kernels
    "emacs-paredit" ;; Emacs minor mode for editing parentheses
    "emacs-pgtk" ;; Emacs text editor with `pgtk' frames
    "emacs-smartparens" ;; Paredit-like insertion, wrapping and navigation with user defined pairs
    "emacs-trashed" ;; View and edit system trash can in Emacs
    "vim" ;; Text editor based on vi
    ))

(define %package-management-utilities
  ;; Package Management and Utilities
  '("dpkg" ;; Debian package management system
    "guile" ;; Scheme implementation intended especially for extensions
    "guile-colorized" ;; Colorized REPL for Guile
    "guile-gcrypt" ;; Cryptography library for Guile using Libgcrypt
    "guile-readline" ;; Line editing support for GNU Guile
    "pkg-config" ;; Helper tool used when compiling applications and libraries
    ))

(define %web-browsers
  ;; Web Browsers
  '("firefox-esr" ;; Trademarkless version of Firefox
    "ungoogled-chromium-wayland" ;; Graphical web browser
    "ublock-origin-chromium" ;; Block unwanted content from web sites
    ))

(define %security-authentication-tools
  ;; Security and Authentication Tools
  '("gnupg" ;; GNU Privacy Guard
    "libyubikey" ;; Development kit for the YubiKey authentication device
    "pcsc-lite" ;; Middleware to access a smart card using PC/SC
    "pcsc-tools" ;; Smart cards and PC/SC tools
    "pinentry" ;; GnuPG's interface to passphrase input
    "pinentry-qt" ;; GnuPG's interface to passphrase input
    "yubico-pam" ;; Yubico pluggable authentication module
    ))

(define %office-document-tools
  ;; Office and Document Tools
  '("libreoffice" ;; Office suite
    "texinfo" ;; The GNU documentation format
    "keepassxc" ;; Password manager (Added category packages)
    ))

(define %monitoring-performance-tools
  ;; Monitoring and Performance Tools
  '("glances" ;; Cross-platform curses-based monitoring tool
    "htop" ;; Interactive process viewer
    "iotop" ;; Interactive `top'-like input/output activity monitor
    "libvirt" ;; Simple API for virtualization
    "nmon" ;; Monitor system performance in a terminal or to a `.csv' log file
    "rocm-comgr" ;; ROCm Compiler Driver
    "rocm-device-libs" ;; ROCm Device Libraries
    "rocr-runtime" ;; ROCm Runtime
    ))

(define %file-disk-management-tools
  ;; File and Disk Management Tools
  '("gparted" ;; Partition editor to graphically manage disk partitions
    "gptfdisk" ;; Low-level GPT disk partitioning and formatting
    "po4a" ;; Tools for using PO files
    "rsync" ;; Remote (and local) file copying tool
    "trash-cli" ;; Trash can management tool
    "tree" ;; Recursively list the contents of a directory
    "unzip" ;; Decompression and file extraction utility
    "zip" ;; Compression and file packing utility
    ))

(define %utilities-miscellaneous-tools
  ;; Utilities and Miscellaneous Tools
  '("cloc" ;; Count source lines of code (SLOC) and other source code metrics
    "cmatrix" ;; Simulate the display from "The Matrix"
    "moreutils" ;; Miscellaneous general-purpose command-line tools
    "neofetch" ;; System information script
    "recutils" ;; Manipulate plain text files as databases
    "sendmail" ;; Highly configurable Mail Transfer Agent (MTA)
    "socat" ;; Open bidirectional communication channels from the command line
    "sqlitebrowser" ;; Visual database browser and editor for SQLite
    "synergy" ;; Mouse and keyboard sharing utility
    "v4l-utils" ;; Realtime video capture utilities for Linux
    "xinit" ;; Commands to start the X Window server
    "xhost" ;; Xorg server access control utility
    "xkbutils" ;; XKB utilities
    "zoom" ;; Zoom video conferencing software
    ))

(define %scientific-technical-computing
  ;; Scientific and Technical Computing
  '("julia" ;; High-performance dynamic language for technical computing
    "jupyter" ;; Web application for interactive documents
    "kicad" ;; Electronic design automation suite
    "kicad-doc" ;; Documentation for KiCad
    "qgis" ;; Geographical information system
    ))

(define %printers-hardware-tools
  ;; Printers and Hardware Tools
  '("dmidecode" ;; Read hardware information from the BIOS
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
          %monitoring-performance-tools
          %file-disk-management-tools
          %utilities-miscellaneous-tools
          %scientific-technical-computing
          %printers-hardware-tools))

(define cdo-home-environment
  (home-environment
   (packages (specifications->packages %cdo-packages))
   (services
    (list
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
     (service home-xdg-configuration-files-service-type
              `(("fish/fish_variables" ,(local-file "./fish/fish_variables"))
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
     (service home-channels-service-type
              cdo-guix-channels)
     ;;; Disabled. Currently failing on my machine
     ;;(service home-redshift-service-type
     ;;         (home-redshift-configuration
     ;;          (location-provider 'manual)
     ;;          (latitude 51.5)
     ;;          (longitude -0.1)))
     ))))

cdo-home-environment
