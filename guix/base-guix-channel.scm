(use-modules (guix ci))

(list (channel-with-substitutes-available (channel
	(name 'guix)
	;(branch 'staging)
	(url "https://git.savannah.gnu.org/git/guix.git")
	(introduction (make-channel-introduction
		"9a2e8664ecd0b7fe3371cb268506e68037b3263d"
		(openpgp-fingerprint
			"BBB0 2DDF 2CEA F6A8 0D1D  E643 A2A0 6DF2 A33A 54FA"))))
        "https://ci.guix.gnu.org"))
