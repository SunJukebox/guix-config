;; This "home-environment" file can be passed to 'guix home reconfigure'
;; to reproduce the content of your profile.  This is "symbolic": it only
;; specifies package names.  To reproduce the exact same profile, you also
;; need to capture the channels being used, as returned by "guix describe".
;; See the "Replicating Guix" section in the manual.

(define-module (home home-conf)
  #|GNU|#
  #:use-module (gnu)
  #:use-module (gnu home)

  #|GNU Home Services|#
  #:use-module (gnu home services)
  #:use-module (gnu home services desktop)
  #:use-module (gnu home services gnupg)
  #:use-module (gnu home services shells)
  #:use-module (gnu home services shepherd)
  #:use-module (gnu home services sound)

  #|GNU Packages|#
  #:use-module (gnu packages admin)
  #:use-module (gnu packages chromium)
  #:use-module (gnu packages fonts)
  #:use-module (gnu packages freedesktop)
  #:use-module (gnu packages gnupg)
  #:use-module (gnu packages librewolf)
  #:use-module (gnu packages linux)
  #:use-module (gnu packages package-management)
  #:use-module (gnu packages password-utils)
  #:use-module (gnu packages pdf)
  #:use-module (gnu packages pulseaudio)
  #:use-module (gnu packages shells)
  #:use-module (gnu packages shellutils)
  #:use-module (gnu packages terminals)
  #:use-module (gnu packages vim)
  #:use-module (gnu packages wm)
  #:use-module (gnu packages xdisorg)
  #:use-module (gnu packages xorg)

  #|Guix|#
  #:use-module (guix gexp)

  #|My Things|#
  ;; TODO Put these in a channel
  #:use-module (packages fonts)
  #:use-module (home services foot))

(define packages:desktop
  (list #|freedesktop|# xdg-utils xdg-desktop-portal xdg-desktop-portal-gtk xdg-desktop-portal-wlr))

(define-public my-home-environment
  (home-environment
   ;; Below is the list of packages that will show up in your
   ;; Home profile, under ~/.guix-home/profile.
   ;; (packages (list ))
   
   ;; Below is the list of Home services.  To search for available
   ;; services, run 'guix home search KEYWORD' in a terminal.
   (services
    (list (simple-service 'my-desktop-profile-service home-profile-service-type
                          (list
                           ;; window manager
                           sway
                           swayidle
                           swaylock
                           foot
                           fuzzel
                           mako
                           grimshot

                           ;; flatpak
                           flatpak
                           flatpak-xdg-utils

                           ;; xwayland
                           xorg-server-xwayland

                           ;; password manager
                           gnupg
                           ;; pinentry-emacs
                           password-store

                           ;; zsh
                           zsh
                           zsh-autosuggestions
                           zsh-completions
                           zsh-syntax-highlighting

                           ;; font
                           font-jetbrains-mono-nf
                           font-adobe-source-han-sans

                           ;; zathura (pdf & djvu)
                           zathura
                           zathura-djvu
                           zathura-pdf-mupdf

                           ;; browsers
                           ungoogled-chromium
                           librewolf

                           ;; clipboard
                           ;; xclip
                           wl-clipboard

                           ;; sound
                           pipewire
                           wireplumber-minimal
                           pulsemixer))
          
          (simple-service 'my-env-vars-service
                          home-environment-variables-service-type
                          `(("SHELL" unquote
                             (file-append zsh "/bin/zsh"))
                            ("PATH" . "$HOME/.local/bin:$PATH")
                            ("GUIX_PROFILE" . "$HOME/.guix-profile")

                            ;; Configure pinentry to use correct TTY
                            ("GPG_TTY" . "$(tty)")

                            ;; Use XDG Specification
                            ("PASSWORD_STORE_DIR" . "$XDG_DATA_HOME/pass")

                            ;; Wayland-specific environment variables
                            ("XDG_CURRENT_DESKTOP" . "sway")
                            ("XDG_SESSION_TYPE" . "wayland")
                            ("RTC_USE_PIPEWIRE" . "true")
                            ("SDL_VIDEODRIVER" . "wayland")
                            ("MOZ_ENABLE_WAYLAND" . "1")
                            ("CLUTTER_BACKEND" . "wayland")
                            ("ELM_ENGINE" . "wayland_egl")
                            ("ECORE_EVAS_ENGINE" . "wayland-egl")
                            ("QT_QPA_PLATFORM" . "wayland-egl")))

          (service home-zsh-service-type
                   (home-zsh-configuration (zshrc (list (local-file
                                                         "../files/.config/zsh/.zshrc"
                                                         "zshrc")))))

          (service home-xdg-configuration-files-service-type
                   `( ;neovim
                     ("nvim/init.lua" ,(local-file "../files/.config/nvim/init.lua"))
                     ("nvim/lua" ,(local-file "../files/.config/nvim/lua"
                                              #:recursive? #t))
                     ("nvim/snippets" ,(local-file "../files/.config/nvim/snippets"
                                                   #:recursive? #t))

                     ;; emacs
                     ("emacs/early-init.el" ,(local-file
                                              "../files/.config/emacs/early-init.el"))
                     ("emacs/init.el" ,(local-file "../files/.config/emacs/init.el"))

                     ;; sway
                     ("sway/config" ,(local-file "../files/.config/sway/config"))))

          (service home-dbus-service-type)

          (service home-pipewire-service-type)

          (service home-gpg-agent-service-type
                   (home-gpg-agent-configuration (pinentry-program (file-append
                                                                    pinentry
                                                                    "/bin/pinentry-gtk-2"))
                                                 (ssh-support? #t)
                                                 (extra-content "enable-ssh-support")))))))
;; (service home-foot-service-type))))

my-home-environment
