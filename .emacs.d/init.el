(custom-set-variables
 ;; custom-set-variables was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 '(custom-safe-themes
   (quote
    ("d677ef584c6dfc0697901a44b885cc18e206f05114c8a3b7fde674fce6180879" "8aebf25556399b58091e533e455dd50a6a9cba958cc4ebb0aab175863c25b9a4" default)))
 '(show-paren-mode t)
 '(tool-bar-mode nil))
(custom-set-faces
 ;; custom-set-faces was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 '(default ((t (:family "DejaVu Sans" :foundry "PfEd" :slant normal :weight normal :height 72 :width normal)))))

(setq confirm-kill-emacs 'yes-or-no-p)

(setq shell-file-name "zsh")
(setq shell-command-switch "-ic")

;;; Initialize MELPA
(require 'package)
(add-to-list 'package-archives '("melpa" . "http://melpa.milkbox.net/packages/"))
(unless package-archive-contents (package-refresh-contents))
(package-initialize)

(unless (package-installed-p 'clojure-mode)
  (package-install 'clojure-mode))

(defvar to-install '(
                     fsharp-mode
                     evil
                     escreen
                     column-marker
                     smooth-scrolling
                     linum-relative
                     php-mode
                     web-mode
                     flycheck
                     helm
                     helm-ag
                     tramp
                     dirtree
                     dired+
                     nyan-mode
                     monokai-theme
                     solarized-theme))
(dolist (element to-install)
    (unless (package-installed-p element)
      (package-install element))
  )

(defvar to-require '(
    fsharp-mode
    evil
    escreen
    column-marker
    php-mode
    helm-config
    dirtree
    dired+
    web-mode
    smooth-scrolling
    linum-relative
    solarized-theme
    tramp))

(dolist (element to-require)
  (require element))

;(unless (package-installed-p 'clj-refactor)
;  (package-install 'clj-refactor))
;(require 'clj-refactor)
;(defun my-clojure-mode-hook ()
;    (clj-refactor-mode 1)
;    (yas-minor-mode 1) ; for adding require/use/import
;    (cljr-add-keybindings-with-prefix "C-c C-m"))
;(add-hook 'clojure-mode-hook #'my-clojure-mode-hook)

(add-hook 'clojure-mode-hook #'subword-mode)
(add-hook 'clojure-mode-hook #'smartparens-strict-mode)

(evil-mode 1)
(setq evil-ex-substitute-global t)  ; Like Vim's gdefault

;(load-theme 'solarized-dark)
(load-theme 'monokai t)

(escreen-install)

;(helm-mode 1)
(global-set-key (kbd "M-x") 'helm-M-x)
(global-set-key (kbd "C-x C-f") 'helm-find-files)
(setq helm-M-x-fuzzy-match t)
(global-set-key (kbd "C-x b") 'helm-mini)
(setq helm-buffers-fuzzy-matching t
    helm-recentf-fuzzy-match t)

(add-to-list 'auto-mode-alist '("\\.phtml\\'" . web-mode))
(add-to-list 'auto-mode-alist '("\\.tpl\\.php\\'" . web-mode))
(add-to-list 'auto-mode-alist '("\\.[agj]sp\\'" . web-mode))
(add-to-list 'auto-mode-alist '("\\.as[cp]x\\'" . web-mode))
(add-to-list 'auto-mode-alist '("\\.erb\\'" . web-mode))
(add-to-list 'auto-mode-alist '("\\.mustache\\'" . web-mode))
(add-to-list 'auto-mode-alist '("\\.djhtml\\'" . web-mode))
(add-to-list 'auto-mode-alist '("\\.html?\\'" . web-mode))

(global-visual-line-mode t)

(setq frame-title-format
    (list (format "%s %%S: %%j " (system-name))
        '(buffer-file-name "%f" (dired-directory dired-directory "%b"))))

(show-paren-mode 1)

; Disable highlight-copies-to-clipboard
; Also fixes Evil destroying your clipboard
(setq x-select-enable-clipboard nil)
(setq x-select-enable-primary t)
(setq mouse-drag-copy-region nil)

;; flycheck
(add-hook 'after-init-hook #'global-flycheck-mode)

(setq smooth-scroll-margin 5)

;(after 'flycheck
;  (setq flycheck-check-syntax-automatically '(save mode-enabled))
;  (setq flycheck-checkers (delq 'emacs-lisp-checkdoc flycheck-checkers))
;  (setq flycheck-checkers (delq 'html-tidy flycheck-checkers))
;  (setq flycheck-standard-error-navigation nil))
;(global-flycheck-mode t)
;;; flycheck errors on a tooltip (doesnt work on console)
;(when (display-graphic-p (selected-frame))
;  (eval-after-load 'flycheck
;    '(custom-set-variables
;      '(flycheck-display-errors-function #'flycheck-pos-tip-error-messages))))

; Place temp / backup files in /tmp, not in the working file tree
(setq backup-directory-alist
      `((".*" . , temporary-file-directory)))
(setq auto-save-file-name-transforms
      `((".*" , temporary-file-directory t)))

; Bind Shift-<arrow> to navigating windows
(windmove-default-keybindings)
; Disable tabs, use spaces
(setq-default indent-tabs-mode nil)

;; scroll one line at a time (less "jumpy" than defaults)
(setq mouse-wheel-scroll-amount '(1 ((shift) . 1))) ;; one line at a time
(setq mouse-wheel-progressive-speed nil) ;; don't accelerate scrolling
(setq mouse-wheel-follow-mouse 't) ;; scroll window under mouse
(setq scroll-step 1) ;; keyboard scroll one line at a time

(global-linum-mode 1)
(linum-relative-mode)

;(set-default 'tramp-default-proxies-alist (quote ((".*" "\\`root\\'" "/ssh:%h:"))))  ; Enable sudo support in tramp
(set-default 'tramp-default-proxies-alist (quote ((".*" "\\`root\\'" "/scp%h:"))))  ; Enable sudo support in tramp
