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
	        (branch "staging")
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
       ("XDG_CACHE_HOME" . "$HOME/.local/cache")
       ("XDG_CONFIG_HOME" . "$HOME/.config")
       ("XDG_DATA_HOME" . "$HOME/.local/data")
       ("XDG_DOWNLOAD_DIR" . "$HOME/downloads")
       ("XDG_PICTURES_DIR" . "$HOME/images")
       ("XDG_STATE_HOME" . "$HOME/.local/state")
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
       ("HISTFILE" . "$XDG_DATA_HOME/shell/histfile")
       ("ICEAUTHORITY" . "$XDG_CACHE_HOME/x11/ICEauthority")
       ("JULIA_DEPOT_PATH" . "$XDG_DATA_HOME/julia:$GUIX_PROFILE/share/julia/")
       ("LESSHISTFILE" . "$XDG_CONFIG_HOME/less/hist")
       ("LESSKEY" . "$XDG_CONFIG_HOME/less/keys")
       ("MPLAYER_HOME" . "$XDG_CONFIG_HOME/mplayer")
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

(define %cdo-packages
  (list "adwaita-icon-theme"
        "alacritty"
        "ansible"
        "autoconf"
        "automake"
        "basu"
        "bridge-utils"
        "ccid"
        "clang"
        "cloc"
        "cmatrix"
        "coreutils"
        "cryptsetup"
        "curl"
        "dbus"
        "ddrescue"
        "diffutils"
        "dpkg"
        "dwm"
        "emacs-all-the-icons"
        "emacs-counsel"
        "emacs-counsel-tramp"
        "emacs-debbugs"
        "emacs-exwm"
        "emacs-git-email"
        "emacs-guix"
        "emacs-ivy"
        "emacs-jupyter"
        "emacs-paredit"
        "emacs-pgtk"
        "emacs-smartparens"
        "emacs-trashed"
        "festival"
        "file"
        "fish"
        "ffmpeg"
        "font-adobe-source-code-pro"
        "fontconfig"
        "font-gnu-unifont"
        "font-google-noto"
        "gcc-toolchain"
        "gdb"
        "gettext"
        "git"
        "git:send-email"
        "glances"
	"gnome"
        "gnome-calculator"
        "gnupg"
        "go"
        "gparted"
        "gptfdisk"
        "graphviz"
        "greetd"
        "grim"
        "guvcview"
        "guile"
        "guile-colorized"
        "guile-gcrypt"
        "guile-readline"
        "htop"
        "hwdata"
        "icedove-wayland"
        "iotop"
        "ispell"
        "julia"
        "jupyter"
        "kdenlive"
        "keepassxc"
        "kicad"
        "kicad-doc"
        "kicad-footprints"
        "kicad-packages3d"
        "kicad-symbols"
        "kicad-templates"
        "libcap"
        "libfido2"
        "libiconv"
        "libreoffice"
        "libtool"
        "libu2f-host"
        "libvirt"
        "libyubikey"
        "linux-pam"
        "lm-sensors"
        "lsof"
        "lynx"
        "mailutils"
        "make"
        "matcha-theme"
        "mediainfo"
        "meld"
        "moreutils"
        "neofetch"
        "nmon"
        "nomacs"
        "obs"
        "okular"
        "opencl-headers"
        "openjdk"
        "openssl"
        "orca"
        "ovmf"
        "pamixer"
        "pam-u2f"
        "pavucontrol"
        "pcsc-lite"
        "pcsc-tools"
        "pinentry"
        "pinentry-qt"
        "pkg-config"
        "po4a"
        "pulseaudio-qt"
        "pv"
        "python"
        "python-pip"
        "python-pyopencl"
        "qemu"
        "qtwayland"
        "readline"
        "recutils"
        "rocm-comgr"
        "rocm-device-libs"
        "rocr-runtime"
        "rsync"
        "rust-cargo"
        "screen"
        "sddm"
        "sendmail"
        "slurp"
        "socat"
        "speech-dispatcher"
        "sqlitebrowser"
        "strace"
        "sway"
        "syncthing"
        "synergy"
        "texinfo"
        "tor"
        "tor-client"
        "trash-cli"
        "tree"
        "ublock-origin-chromium"
        "ungoogled-chromium-wayland"
        "unison"
        "unzip"
        "vim"                            ; For quick editing
        "virt-manager"
        "vinagre"
        "vlc"
        "waybar"
        "wofi"
        "xdg-desktop-portal-kde"
        "xdg-user-dirs"
        "xinit"
        "xhost"
        "xkbutils"
        "xorg-server"
        "xorg-server-xwayland"
        "ykclient"
        "yubico-pam"
        "zip"))

(define cdo-home-environment
  (home-environment
   (packages (specifications->packages %cdo-packages))
   (services
    (list
     (service home-fish-service-type (home-fish-configuration
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
     (service home-redshift-service-type
              (home-redshift-configuration
               (location-provider 'manual)
               (latitude 51.5)
               (longitude -0.1)))))))

cdo-home-environment
