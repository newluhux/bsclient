(use-modules
 (gnu)
 (gnu packages)
 (gnu packages linux)
 (gnu packages golang)
 (gnu packages check)
 (gnu packages haskell-xyz)
 (guix build-system gnu)
 (guix gexp)
 (guix records)
 (guix git-download)
 (guix packages)
 (guix utils)
 (guix licenses))

(define-public earlyoom-162
  (package
    (name "earlyoom")
    (version "1.6.2")
    (source (origin
              (method git-fetch)
              (uri (git-reference
                    (url "https://github.com/rfjakob/earlyoom")
                    (commit (string-append "v" version))))
              (file-name (git-file-name name version))
              (sha256
               (base32
                "16iyn51xlrsbshc7p5xl2338yyfzknaqc538sa7mamgccqwgyvvq"))))
    (build-system gnu-build-system)
    (arguments
     (list
       #:phases
       #~(modify-phases %standard-phases
           (delete 'configure))           ; no configure script
       #:make-flags
       #~(list (string-append "CC=" #$(cc-for-target))
               (string-append "VERSION=v" #$version)
               (string-append "PREFIX=" #$output)
               (string-append "SYSCONFDIR=" #$output "/etc")
               "GO111MODULE=off")
       #:tests? #f)) ; 测试用例要求权限过高，驳回
    (native-inputs
      (append
        ;; To generate the manpage.
        (if (or (target-x86-64?) (target-x86-32?))
          (list pandoc)
          '())
        (list
          ;; For the test suite.
          cppcheck
          go)))
    (home-page "https://github.com/rfjakob/earlyoom")
    (synopsis "Simple out of memory (OOM) daemon for the Linux kernel")
    (description "Early OOM is a minimalist out of memory (OOM) daemon that
runs in user space and provides a more responsive and configurable alternative
to the in-kernel OOM killer.")
    (license expat)))
