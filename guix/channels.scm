(use-modules (guix ci))

(define %guix-base-channel
  (channel
	 (name 'guix)
   ;; (branch 'staging)
	 (url "https://git.savannah.gnu.org/git/guix.git")
	 (introduction (make-channel-introduction
		              "9a2e8664ecd0b7fe3371cb268506e68037b3263d"
		              (openpgp-fingerprint
			             "BBB0 2DDF 2CEA F6A8 0D1D  E643 A2A0 6DF2 A33A 54FA")))))

(define %guix-with-substitutes-channel
  (channel-with-substitutes-available
   %guix-base-channel
   "https://ci.guix.gnu.org"))

(define %nonguix-channel
  (channel
	 (name 'nonguix)
	 (url "https://gitlab.com/nonguix/nonguix")
	 (introduction (make-channel-introduction
		              "897c1a470da759236cc11798f4e0a5f7d4d59fbc"
		              (openpgp-fingerprint
			             "2A39 3FFF 68F4 EF7A 3D29  12AF 6F51 20A0 22FB B2D5")))))

(define %channels
  (list %guix-base-channel
        ))

%channels
