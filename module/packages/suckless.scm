(use-modules
 (gnu)
 (gnu packages)
 (gnu packages suckless)
 (guix build-system gnu)
 (guix gexp)
 (guix records)
 (guix download)
 (guix packages))

(define-public dwm-modify
 (package
   (inherit dwm)
   (name "dwm-modify")
   (source
    (local-file "src/dwm-modify"
     #:recursive? #t))))

(define-public surf-modify
 (package
  (inherit surf)
  (name "surf-modify")
  (source
   (local-file 
    "src/surf-modify"
    #:recursive? #t))))

surf-modify
