;; This "home-environment" file can be passed to 'guix home reconfigure'
;; to reproduce the content of your profile.  This is "symbolic": it only
;; specifies package names.  To reproduce the exact same profile, you also
;; need to capture the channels being used, as returned by "guix describe".
;; See the "Replicating Guix" section in the manual.

(use-modules (gnu)
             (gnu home)
             (gnu home services)
             (gnu home services shells)
             (gnu home services fontutils)
             (gnu home services mcron)
             (gnu home services desktop)
             (gnu home services guix)
             (gnu packages)
             (gnu services)
             (gnu services mcron)
             (guix channels)
             (guix gexp)
             (guix ci))

(define cdo-guix-channels
  (list (channel-with-substitutes-available
         (channel
	        (name 'guix)
	        (branch 'staging)
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

       ("BZR_HOME" . "$XDG_CACHE_HOME/bazaar")
       ("BZRPATH" . "$XDG_CONFIG_HOME/bazaar")
       ("BZR_PLUGIN_PATH" . "$XDG_DATA_HOME/bazaar")
       ("CARGO_HOME" . "$XDG_DATA_HOME/cargo")
       ("GNUPGHOME" . "$HOME/.local/secure/gnupg")
       ("GOBIN" . "$HOME/.local/bin")
       ("GOCACHE" . "$XDG_CACHE_HOME/go")
       ("GOMODCACHE" . "$XDG_CACHE_HOME/go/modules")
       ("GOROOT" . "/lib/go")
       ("GOTMPDIR" . "/tmp")
       ("GOTOOLDIR" . "$XDG_DATA_HOME/go")
       ("HISTFILE" . "$XDG_DATA_HOME/shell/histfile")
       ("ICEAUTHORITY" . "$XDG_CACHE_HOME/x11/ICEauthority")
       ("JULIA_DEPOT_PATH" . "$XDG_DATA_HOME/julia:$JULIA_DEPOT_PATH")
       ("LESSHISTFILE" . "$XDG_CONFIG_HOME/less/hist")
       ("LESSKEY" . "$XDG_CONFIG_HOME/less/keys")
       ("MPLAYER_HOME" . "$XDG_CONFIG_HOME/mplayer")
       ("PYTHONHISTFILE" . "$XDG_DATA_HOME/python/histfile")
       ("PYTHONSTARTUP" . "$XDG_CONFIG_HOME/python/startup.py")
       ("SPACEMACSDIR" . "$XDG_CONFIG_HOME/spacemacs")
       ("SUBVERSION_HOME" . "$XDG_CONFIG_HOME/subversion")
       ("VIMDOTDIR" . "$XDG_CONFIG_HOME/vim")
       ("XAUTHORITY" . "$XDG_DATA_HOME/x11/xAuthority")))

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

(define cdo-home-environment
  (home-environment
   (packages (specifications->packages (list
                                             "adwaita-icon-theme"
                                             "alacritty"
                                             "autoconf"
                                             "basu"
                                             "ccid"
                                             "clang"
                                             "cloc"
                                             "cmatrix"
                                             "coreutils"
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
                                             "emacs-guix"
                                             "emacs-ivy"
                                             "emacs-next-pgtk"
                                             "emacs-paredit"
                                             "emacs-smartparens"
                                             "file"
                                             "fish"
                                             "font-adobe-source-code-pro"
                                             "fontconfig"
                                             "font-gnu-unifont"
                                             "font-google-noto"
                                             "gcc-toolchain"
                                             "gdb"
                                             "git"
                                             "gnupg"
                                             "go"
                                             "greetd"
                                             "guile"
                                             "guile-colorized"
                                             "guile-readline"
                                             "htop"
                                             "hwdata"
                                             "icedove-wayland"
                                             "ispell"
                                             "julia"
                                             "keepassxc"
                                             "kicad"
                                             "kicad-doc"
                                             "kicad-footprints"
                                             "kicad-packages3d"
                                             "kicad-symbols"
                                             "kicad-templates"
                                             "libcap"
                                             "libiconv"
                                             "libreoffice"
                                             "libtool"
                                             "libyubikey"
                                             "linux-pam"
                                             "lm-sensors"
                                             "lynx"
                                             "mailutils"
                                             "make"
                                             "matcha-theme"
                                             "meld"
                                             "moreutils"
                                             "nmon"
                                             "nomacs"
                                             ;; "nvidia-settings"
                                             ;; "nvidia-system-monitor"
                                             "okular"
                                             "openjdk"
                                             "openssl"
                                             "orca"
                                             "pam-u2f"
                                             "pinentry"
                                             "po4a"
                                             "pv"
                                             "python"
                                             "qemu"
                                             "readline"
                                             "recutils"
                                             "rsync"
                                             "rust-cargo"
                                             "screen"
                                             "sddm"
                                             "sendmail"
                                             "speech-dispatcher"
                                             "sway"
                                             "syncthing"
                                             "texinfo"
                                             "tor"
                                             "tor-client"
                                             "tree"
                                             "ublock-origin-chromium"
                                             "ungoogled-chromium-wayland"
                                             "unison"
                                             "unzip"
                                             "vlc"
                                             "waybar"
                                             "wofi"
                                             "xdg-desktop-portal-kde"
                                             "xdg-user-dirs"
                                             "xinit"
                                             "xkbutils"
                                             "xorg-server"
                                             "yubico-pam"
                                             "zip")))

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
                ;; ("fontconfig" ,(local-file "./fontconfig" #:recursive? #t))
                ("gh" ,(local-file "./gh" #:recursive? #t))
                ("git" ,(local-file "./git" #:recursive? #t))
                ;; ("guix/channels.scm" ,(local-file "guix/channels.scm"))
                ("hexchat" ,(local-file "./hexchat" #:recursive? #t))
                ("shell" ,(local-file "./shell" #:recursive? #t))
                ("spacemacs/init.el" ,(local-file "./spacemacs/init.el"))
                ("sway" ,(local-file "./sway" #:recursive? #t))
                ("swaylock/config" ,(local-file "./swaylock/config"))
                ("user-dirs.dirs" ,(local-file "./user-dirs.dirs"))
                ("waybar" ,(local-file "./waybar" #:recursive? #t))
                ("wofi" ,(local-file "./wofi" #:recursive? #t))))
     (service home-channels-service-type
              cdo-guix-channels))
     )))

;;; The following error occurs when trying to reload herd after a reconfigure.
;;; herd: error: exception caught while executing 'load' on service 'root':
;;; Wrong number of arguments to #<procedure 7f04867be6e0 at shepherd/service.scm:2773:6 (running file-name)>
;; (service home-redshift-service-type
;;          (home-redshift-configuration
;;           (location-provider 'manual)
;;           (latitude 51.5)
;;           (longitude -0.1)))

cdo-home-environment
