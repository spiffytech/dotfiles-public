(custom-set-variables
 ;; custom-set-variables was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 '(custom-safe-themes (quote ("d677ef584c6dfc0697901a44b885cc18e206f05114c8a3b7fde674fce6180879" "8aebf25556399b58091e533e455dd50a6a9cba958cc4ebb0aab175863c25b9a4" default))))
(custom-set-faces
 ;; custom-set-faces was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 )

;;; Initialize MELPA
(require 'package)
(add-to-list 'package-archives '("melpa" . "http://melpa.milkbox.net/packages/"))
(unless package-archive-contents (package-refresh-contents))
(package-initialize)

;;; Install fsharp-mode
(unless (package-installed-p 'fsharp-mode)
  (package-install 'fsharp-mode))
(require 'fsharp-mode)

(unless (package-installed-p 'evil)
  (package-install 'evil))
(require 'evil)
(evil-mode 1)

(unless (package-installed-p 'solarized-theme)
  (package-install 'solarized-theme))
(require 'solarized-theme)
(load-theme 'solarized-dark)

(unless (package-installed-p 'elscreen)
  (package-install 'elscreen))
;(require 'ElScreen)
(load "elscreen" "ElScreen" t)
(elscreen-start)

;(unless (package-installed-p 'helm-config)
;  (package-install 'helm-config))
;(unless (package-installed-p 'helm-misc)
;  (package-install 'helm-misc))
;(unless (package-installed-p 'helm-projectile)
;  (package-install 'helm-projectile))
;(unless (package-installed-p 'helm-locate)
;  (package-install 'helm-locate))
;(require 'helm-config)
;(require 'helm-misc)
;(require 'helm-projectile)
;(require 'helm-locate)
(unless (package-installed-p 'helm)
  (package-install 'helm))
(require 'helm)

(helm-mode 1)

(unless (package-installed-p 'linum-relative)
  (package-install 'linum-relative))
(require 'linum-relative)
(linum-mode)
