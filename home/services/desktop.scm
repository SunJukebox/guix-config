(define-module (my-home services desktop)
  #:use-module (gnu)
  #:use-module (gnu packages))

(define my-home-desktop-profile-service
  (list sway
        swayidle
        swaylock
        foot
        fuzzel
        wlgreet))
