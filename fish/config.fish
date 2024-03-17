if status --is-login
	set -x PATH ~/.cargo/bin /lib/go/bin ~/scripts ~/.local/bin $PATH
	set -x GPG_TTY (tty)
end

direnv hook fish | source
