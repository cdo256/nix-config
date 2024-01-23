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

(define %nonguix-local-channel
  (channel
	 (name 'nonguix)
   (branch 'local-testing)
   (url (string-append "file://" (getenv "HOME") "/src/nonguix"))
	 (introduction (make-channel-introduction
		              "897c1a470da759236cc11798f4e0a5f7d4d59fbc"
		              (openpgp-fingerprint
			             "2A39 3FFF 68F4 EF7A 3D29  12AF 6F51 20A0 22FB B2D5")))))

(define %nonguix-channel
  (channel
	 (name 'nonguix)
   (url "https://gitlab.com/nonguix/nonguix")
	 (introduction (make-channel-introduction
		              "897c1a470da759236cc11798f4e0a5f7d4d59fbc"
		              (openpgp-fingerprint
			             "2A39 3FFF 68F4 EF7A 3D29  12AF 6F51 20A0 22FB B2D5"))))))

(define %rde-channel
  (channel
   (name 'rde)
   (url "https://git.sr.ht/~abcdw/rde")
   (introduction
    (make-channel-introduction
     "257cebd587b66e4d865b3537a9a88cccd7107c95"
     (openpgp-fingerprint
      "2841 9AC6 5038 7440 C7E9  2FFA 2208 D209 58C1 DEB0")))))

(define %cdo-channel
  (channel
   (name 'cdo)
   (url "https://git.mutix.org/cdo-guix-channel.git")
   (introduction (make-channel-introduction
                  "0530e990813d616079686004f1d52c9ffe4dfd91"
                  (openpgp-fingerprint
                   "358B 3178 BAC1 BA9B 105C   5CDA 344C 0AA8 A41E 474A")))))

(define %channels
  (list %guix-with-substitutes-channel
        %nonguix-channel
        %cdo-channel))

%channels
