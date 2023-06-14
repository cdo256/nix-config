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
             (gnu packages)
             (gnu services)
             (gnu services mcron)
             (guix gexp))

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
         (packages (specifications->packages (list "screen"
                                                   "emacs-debbugs"
                                                   "alacritty"
                                                   "nvidia-system-monitor"
                                                   "fish"
                                                   "cloc"
                                                   "ublock-origin-chromium"
                                                   "xkbutils"
                                                   "gcc-toolchain"
                                                   "python"
                                                   "yubico-pam"
                                                   "libyubikey"
                                                   "pam-u2f"
                                                   "keepassxc"
                                                   "adwaita-icon-theme"
                                                   "autoconf"
                                                   "basu"
                                                   "ccid"
                                                   "clang"
                                                   "cmatrix"
                                                   "coreutils"
                                                   "curl"
                                                   "dbus"
                                                   "ddrescue"
                                                   "diffutils"
                                                   "dpkg"
                                                   "dwm"
                                                   "emacs-counsel"
                                                   "emacs-counsel-tramp"
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
                                                   "julia"
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
                                                   "nvidia-settings"
                                                   "okular"
                                                   "openjdk"
                                                   "openssl"
                                                   "orca"
                                                   "pinentry"
                                                   "po4a"
                                                   "pv"
                                                   "qemu"
                                                   "readline"
                                                   "recutils"
                                                   "rsync"
                                                   "rust-cargo"
                                                   "sddm"
                                                   "sendmail"
                                                   "speech-dispatcher"
                                                   "sway"
                                                   "syncthing"
                                                   "texinfo"
                                                   "tor"
                                                   "tor-client"
                                                   "tree"
                                                   "ungoogled-chromium-wayland"
                                                   "unison"
                                                   "unzip"
                                                   "vlc"
                                                   "waybar"
                                                   "wofi"
                                                   "xdg-desktop-portal-kde"
                                                   "xdg-user-dirs"
                                                   "xinit"
                                                   "xorg-server"
                                                   "zip")))

         (services
          (list
           (service home-fish-service-type (home-fish-configuration
                                            (environment-variables cdo-environment-variables)
                                            (aliases '())
                                            (config (list (local-file
                                                           "/home/cdo/.config/fish/base-config.fish"
                                                           "config.fish")))))
           (service home-mcron-service-type
            )
           ))))


cdo-home-environment
