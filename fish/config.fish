if status --is-login
	set -x PATH ~/.cargo/bin /lib/go/bin ~/scripts ~/.local/bin $PATH
	set -x GPG_TTY (tty)
end

set -g fish_key_bindings fish_vi_key_bindings

direnv hook fish | source
