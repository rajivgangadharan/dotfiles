(require 'deft)
(require 'package)

(defun set-frame-size-according-to-resolution ()
  (interactive)
  (if window-system
  (progn
    ;; use 120 char wide window for largeish displays
    ;; and smaller 80 column windows for smaller displays
    ;; pick whatever numbers make sense for you
    (if (> (x-display-pixel-width) 1280)
           (add-to-list 'default-frame-alist (cons 'width 120))
           (add-to-list 'default-frame-alist (cons 'width 80)))
    ;; for the height, subtract a couple hundred pixels
    ;; from the screen height (for panels, menubars and
    ;; whatnot), then divide by the height of a char to
    ;; get the height we want
    (add-to-list 'default-frame-alist 
         (cons 'height (/ (- (x-display-pixel-height) 200)
                             (frame-char-height)))))))

(set-frame-size-according-to-resolution)

;; If there are no archived package contents, refresh them
(when (not package-archive-contents)
  (package-refresh-contents))

;; Initializes the package infrastructure
(package-initialize)

(add-to-list 'package-archives
             '(
	       ("melpa" . "http://melpa.org/packages/")
               ("org" . "https://orgmode.org/elpa")
	       ("gnu" . "https://elpa.gnu.org/packages")
	       ("nongnu" . "https://elpa.nongnu.org/nongnu")
	       )
	     ) 
(setq environment '(process-environment))

(custom-set-variables
 ;; custom-set-variables was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 '(column-number-mode t)
 '(custom-enabled-themes '(catppuccin))
 '(custom-safe-themes
   '("d77d6ba33442dd3121b44e20af28f1fae8eeda413b2c3d3b9f1315fbda021992" default))
 '(package-selected-packages
   '(sequences org-unique-id catppuccin-theme flymake-shell flymake-python-pyflakes tree-sitter-ispell tree-sitter-indent tree-sitter-ess-r tree-sitter org-journal pdf-tools flycheck-rust cargo-mode cargo rust-mode es-windows pet citar-org-roam citar bibtex-utils bibtex-completion bibclean-format auto-virtualenv scholar-import elpy unicode-fonts ace-window use-package org-roam xclip exwm))
 '(save-place-mode t)
 '(tool-bar-mode nil)
 '(warning-suppress-types '((comp) (comp))))

(dolist (hook '(text-mode-hook))
  (add-hook hook (lambda () (flyspell-mode 1))))
(set-frame-font "JetBrains Mono 12" nil t)

(setq inhibit-startup-message t)    ;; Hide the startup message

;; Optionally use the `orderless' completion style. See
;; `+orderless-dispatch' in the Consult wiki for an advanced Orderless style
;; dispatcher. Additionally enable `partial-completion' for file path
;; expansion. `partial-completion' is important for wildcard support.
;; Multiple files can be opened at once with `find-file' if you enter a
;; wildcard. You may also give the `initials' completion style a try.

;; Persist history over Emacs restarts. Vertico sorts by history position.
(use-package savehist
  :init
  (savehist-mode))

;; A few more useful configurations...
(use-package emacs
  :init
  ;; Add prompt indicator to `completing-read-multiple'.
  ;; Alternatively try `consult-completing-read-multiple'.
  (defun crm-indicator (args)
    (cons (concat "[CRM] " (car args)) (cdr args)))
  (advice-add #'completing-read-multiple :filter-args #'crm-indicator)

  ;; Do not allow the cursor in the minibuffer prompt
  (setq minibuffer-prompt-properties
        '(read-only t cursor-intangible t face minibuffer-prompt))
  (add-hook 'minibuffer-setup-hook #'cursor-intangible-mode)

  ;; Emacs 28: Hide commands in M-x which do not work in the current mode.
  ;; Vertico commands are hidden in normal buffers.
  ;; (setq read-extended-command-predicate
  ;;       #'command-completion-default-include-p)

  ;; Enable recursive minibuffers
  (setq enable-recursive-minibuffers t))

;; Enable recent files
(require 'recentf)
(recentf-mode 1)

;;(require 'fill-column-indicator)
;;(setq fci-rule-width 1)
;;(setq fci-rule-color "darkblue")
(require 'ob-shell)
(require 'org)
(require 'ox-latex)
(setq org-latex-create-formula-image-program 'dvipng)
(org-babel-do-load-languages
 'org-babel-load-languages
 '(
   (C . t)
   (python . t)
   (R . t)
   (ruby . t)
   (ditaa . t)
   (dot . t)
   (octave . t)
   (sqlite . t)
   (perl . t)
   (shell . t)
   (java . t)
   (latex . t)
  ))

(global-set-key (kbd "C-x o") 'ace-window)

(custom-set-faces
 ;; custom-set-faces was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 '(default ((t (:family "JetBrains Mono" :foundry "JB" :slant normal :weight regular :height 151 :width normal)))))

(defun my-emoji-fonts ()
  (set-fontset-font t 'symbol "Noto Color Emoji")
  (set-fontset-font t 'symbol "Symbola" nil 'append))
  (set-fontset-font t 'symbol "Segoe UI Emoji" nil 'append)
(if (daemonp)
    (add-hook 'server-after-make-frame-hook #'my-emoji-fonts)
  (my-emoji-fonts))
(setq org-image-actual-width 600)


(global-set-key (kbd "M-o") 'ace-window)
(setq aw-keys '(?a ?s ?d ?f ?g ?h ?j ?k ?l))
(defvar aw-dispatch-alist
          '((?x aw-delete-window "Delete Window")
                (?m aw-swap-window "Swap Windows")
                (?M aw-move-window "Move Window")
                (?c aw-copy-window "Copy Window")
                (?j aw-switch-buffer-in-window "Select Buffer")
                (?n aw-flip-window)
                (?u aw-switch-buffer-other-window "Switch Buffer Other Window")
                (?c aw-split-window-fair "Split Fair Window")
                (?v aw-split-window-vert "Split Vert Window")
                (?b aw-split-window-horz "Split Horz Window")
                (?o delete-other-windows "Delete Other Windows")
                (?? aw-show-dispatch-help))
          "List of actions for `aw-dispatch-default'.")

(add-hook 'rust-mode-hook
          (lambda () (setq indent-tabs-mode nil)))
(require 'auto-virtualenv)
(add-hook 'python-mode-hook 'auto-virtualenv-set-virtualenv)
(add-hook 'projectile-after-switch-project-hook 'auto-virtualenv-set-virtualenv)
(require 'flymake-shell)
(add-hook 'sh-set-shell-hook 'flymake-shell-load)

(setq rust-format-on-save t)
(add-hook 'rust-mode-hook
          (lambda () (prettify-symbols-mode)))

(load-theme 'catppuccin :no-confirm)
(setq catppuccin-flavor 'frappe) ;; or 'latte, 'macchiato, or 'mocha
(catppuccin-reload)

;;(push '(".add" . ?+) rust-prettify-symbols-alist)
;; User-Defined init.el ends here

