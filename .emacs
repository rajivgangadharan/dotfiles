(custom-set-variables
 ;; custom-set-variables was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 '(column-number-mode t)
 '(custom-enabled-themes '(adwaita))
 '(package-selected-packages '(orderless use-package vertico org-roam xclip exwm))
 '(save-place-mode t)
 '(tool-bar-mode nil))

(custom-set-faces
 ;; custom-set-faces was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 '(default ((t (:family "JetBrains Mono" :foundry "JB"
			:slant normal
			:weight normal
			:height 120
			:width normal)))
    '(mode-line ((t (:foreground "#030303"
				 :background "#bdbdbd"
				 :box nil))))
    '(mode-line-inactive ((t (:foreground "#f9f9f9"
					  :background "#666666"
					  :box nil))))
    )
 
 '(Info-quoted ((t (:inherit ## :slant normal :width normal :family "JetBrains Mono"))))
 '(bold ((t (:weight bold :width normal :family "JetBrains Mono")))))

(put 'set-goal-column 'disabled nil)
(dolist (hook '(text-mode-hook))
  (add-hook hook (lambda () (flyspell-mode 1))))
(set-frame-font "JetBrains Mono 12" nil t)

(require 'package)

;; If there are no archived package contents, refresh them
(when (not package-archive-contents)
  (package-refresh-contents))

;; Installs packages
;;
;; myPackages contains a list of package names
(defvar myPackages
  '(elpy                            ;; Emacs Lisp Python Environment
    material-theme                  ;; Theme
    )
  )


;; ===================================
;; Basic Customization
;; ===================================
;; (use-package elpy
;;   :ensure t
;;   :init
;;  (elpy-enable) )

;; Adds the Melpa archive to the list of available repositories
(add-to-list 'package-archives
             '("melpa" . "http://melpa.org/packages/") t)

(add-to-list 'package-archives
             '("org" . "https://orgmode.org/elpa") t)

;; For setting up emacs powerline
(add-to-list 'load-path "~/.emacs.d/vendor/emacs-powerline")
(require 'powerline)
;;(require 'cl)


;; Initializes the package infrastructure
(package-initialize)
(require 'package)
(require 'deft)


(setq inhibit-startup-message t)    ;; Hide the startup message
(load-theme 'material t)            ;; Load material theme
(global-linum-mode t)               ;; Enable line numbers globally


;(make-directory "~/Documents/Work/org-roam")
(setq org-roam-directory (file-truename "/run/media/rajivg/LEARNING/Notes/org-roam"))
(require 'org-roam)
(require 'package)
(setq org-startup-with-inline-images t)

(use-package org-roam
    :ensure t
    :custom
    org-roam-directory (file-truename "/run/media/rajivg/LEARNING/Notes/org-roam")
    :bind (("C-c n l" . org-roam-buffer-toggle)
	    ("C-c n f" . org-roam-node-find)
	    ("C-c n i" . org-roam-node-insert))
	     :config )


;; Enable vertico
(use-package vertico
  :init
  (vertico-mode)

  ;; Different scroll margin
  (setq vertico-scroll-margin 0)

  ;; Show more candidates
  (setq vertico-count 20)

  ;; Grow and shrink the Vertico minibuffer
  ;; (setq vertico-resize t)

  ;; Optionally enable cycling for `vertico-next' and `vertico-previous'.
  ;; (setq vertico-cycle t)
  )

;; Optionally use the `orderless' completion style. See
;; `+orderless-dispatch' in the Consult wiki for an advanced Orderless style
;; dispatcher. Additionally enable `partial-completion' for file path
;; expansion. `partial-completion' is important for wildcard support.
;; Multiple files can be opened at once with `find-file' if you enter a
;; wildcard. You may also give the `initials' completion style a try.
(use-package orderless
  :init
  ;; Configure a custom style dispatcher (see the Consult wiki)
  ;; (setq orderless-style-dispatchers '(+orderless-dispatch)
  ;;       orderless-component-separator #'orderless-escapable-split-on-space)
  (setq completion-styles '(orderless)
        completion-category-defaults nil
        completion-category-overrides '((file (styles partial-completion)))))

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
;; User-Defined init.el ends here
