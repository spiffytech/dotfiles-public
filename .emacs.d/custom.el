(setq evil-emacs-state-cursor '("red" box))
(setq evil-normal-state-cursor '("green" box))
(setq evil-visual-state-cursor '("orange" box))
(setq evil-insert-state-cursor '("red" bar))
(setq evil-replace-state-cursor '("red" bar))
(setq evil-operator-state-cursor '("red" hollow))

(desktop-save-mode 1)  ; Auto save / load Emacs sessions on exit / run

; Scroll line by line (with margin), not in large chunks
(setq scroll-margin 5
      scroll-conservatively 9999
      scroll-step 1)

; tabstop = spaces, tab = 4 spaces
(setq-default indent-tabs-mode nil)
(setq-default tab-width 4)
(setq indent-line-function 'insert-tab)
