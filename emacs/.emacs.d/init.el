;;; init.el --- Emacs Configuration -*- lexical-binding: t -*-

;;; Commentary:
;; Main Emacs configuration file

;;; Code:

;; ====================
;; Package Management
;; ====================

(require 'package)

;; Add package archives
(setq package-archives '(("melpa" . "https://melpa.org/packages/")
                         ("melpa-stable" . "https://stable.melpa.org/packages/")
                         ("gnu" . "https://elpa.gnu.org/packages/")))

;; Initialize package system
(package-initialize)

;; Refresh package list if empty
(when (not package-archive-contents)
  (package-refresh-contents))

;; Install use-package if not already installed
(unless (package-installed-p 'use-package)
  (package-install 'use-package))

(require 'use-package)
(setq use-package-always-ensure t)

;; ====================
;; Basic Settings
;; ====================

(setq inhibit-startup-message nil)
(setq inhibit-startup-buffer-menu t)

;; Display settings
(column-number-mode t)
(save-place-mode t)
(tab-bar-mode t)

;; Suppress warnings
(setq warning-suppress-types '((comp) (comp)))

;; Enable recent files
(use-package recentf
  :init
  (recentf-mode 1)
  (setq recentf-max-menu-items 5)
  :bind ("C-x C-r" . recentf-open-files))

;; Persist history over Emacs restarts
(use-package savehist
  :init
  (savehist-mode))

;; ====================
;; UI Configuration
;; ====================

;; Font Configuration
(set-face-attribute 'default nil
                    :family "JetBrains Mono"
                    :foundry "JB"
                    :slant 'normal
                    :weight 'medium
                    :height 135
                    :width 'normal)

;; Emoji font support
(defun my-emoji-fonts ()
  "Set up emoji font support."
  (set-fontset-font t 'symbol "Noto Color Emoji" nil 'prepend)
  (set-fontset-font t 'symbol "Symbola" nil 'append)
  (set-fontset-font t 'symbol "Segoe UI Emoji" nil 'append))

(if (daemonp)
    (add-hook 'server-after-make-frame-hook #'my-emoji-fonts)
  (my-emoji-fonts))

;; Frame size configuration
(defun set-frame-size-according-to-resolution ()
  "Set frame size based on screen resolution."
  (interactive)
  (when window-system
    (if (> (x-display-pixel-width) 1280)
        (add-to-list 'default-frame-alist (cons 'width 100))
      (add-to-list 'default-frame-alist (cons 'width 80)))
    (add-to-list 'default-frame-alist
                 (cons 'height (/ (- (x-display-pixel-height) 300)
                                  (frame-char-height))))))

(set-frame-size-according-to-resolution)

;; ====================
;; Theme
;; ====================

(use-package catppuccin-theme
  :ensure t
  :config
  (setq catppuccin-flavor 'mocha)
  (load-theme 'catppuccin t))

;; ====================
;; Completion & Minibuffer
;; ====================

(use-package emacs
  :init
  ;; Add prompt indicator to completing-read-multiple
  (defun crm-indicator (args)
    (cons (concat "[CRM] " (car args)) (cdr args)))
  (advice-add #'completing-read-multiple :filter-args #'crm-indicator)

  ;; Do not allow the cursor in the minibuffer prompt
  (setq minibuffer-prompt-properties
        '(read-only t cursor-intangible t face minibuffer-prompt))
  (add-hook 'minibuffer-setup-hook #'cursor-intangible-mode)

  ;; Enable recursive minibuffers
  (setq enable-recursive-minibuffers t))

;; ====================
;; Programming Ligatures
;; ====================

(use-package ligature
  :ensure t
  :config
  ;; Enable the www ligature in every possible major mode
  (ligature-set-ligatures 't '("www"))

  ;; Enable ligatures in programming modes
  (ligature-set-ligatures 'prog-mode '("www" "**" "***" "**/" "*>" "*/" "\\\\" "\\\\\\"
                                       "{-" "::" ":::" ":=" "!!" "!=" "!==" "-}" "----"
                                       "-->" "->" "->>" "-<" "-<<" "-~" "#{" "#[" "##"
                                       "###" "####" "#(" "#?" "#_" "#_(" ".-" ".=" ".."
                                       "..<" "..." "?=" "??" ";;" "/*" "/**" "/=" "/=="
                                       "/>" "//" "///" "&&" "||" "||=" "|=" "|>" "^=" "$>"
                                       "++" "+++" "+>" "=:=" "==" "===" "==>" "=>" "=>>"
                                       "<=" "=<<" "=/=" ">-" ">=" ">=>" ">>" ">>-" ">>="
                                       ">>>" "<*" "<*>" "<|" "<|>" "<$" "<$>" "<!--" "<-"
                                       "<--" "<->" "<+" "<+>" "<=" "<==" "<=>" "<=<" "<>"
                                       "<<" "<<-" "<<=" "<<<" "<~" "<~~" "</" "</>" "~@"
                                       "~-" "~>" "~~" "~~>" "%%"))
  (global-ligature-mode t))

;; ====================
;; Window Management
;; ====================

(use-package ace-window
  :ensure t
  :bind (("C-x o" . ace-window)
         ("M-o" . ace-window))
  :config
  (setq aw-keys '(?a ?s ?d ?f ?g ?h ?j ?k ?l))
  (setq aw-dispatch-alist
        '((?x aw-delete-window "Delete Window")
          (?m aw-swap-window "Swap Windows")
          (?M aw-move-window "Move Window")
          (?c aw-copy-window "Copy Window")
          (?j aw-switch-buffer-in-window "Select Buffer")
          (?n aw-flip-window)
          (?u aw-switch-buffer-other-window "Switch Buffer Other Window")
          (?v aw-split-window-vert "Split Vert Window")
          (?b aw-split-window-horz "Split Horz Window")
          (?o delete-other-windows "Delete Other Windows")
          (?? aw-show-dispatch-help))))

;; ====================
;; Org Mode
;; ====================

(use-package org
  :ensure t
  :config
  (setq org-image-actual-width nil)

  ;; Babel configuration
  (require 'ob-shell)
  (org-babel-do-load-languages
   'org-babel-load-languages
   '((C . t)
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
     (latex . t))))

(use-package org-roam
  :ensure t
  :after org
  :custom
  (org-roam-directory (file-truename "~/org-roam/"))
  :bind (("C-c n l" . org-roam-buffer-toggle)
         ("C-c n f" . org-roam-node-find)
         ("C-c n g" . org-roam-graph)
         ("C-c n i" . org-roam-node-insert)
         ("C-c n c" . org-roam-capture)
         ("C-c n j" . org-roam-dailies-capture-today))
  :config
  (org-roam-db-autosync-mode))

(use-package org-journal
  :ensure t
  :defer t)

(use-package deft
  :ensure t
  :after org
  :bind ("C-c d" . deft)
  :custom
  (deft-recursive t)
  (deft-use-filter-string-for-filename t)
  (deft-default-extension "org")
  (deft-directory org-roam-directory))

;; ====================
;; LaTeX Configuration
;; ====================

;; AUCTeX - Advanced LaTeX editing
(use-package tex
  :ensure auctex
  :mode ("\\.tex\\'" . LaTeX-mode)
  :config
  ;; Basic settings
  (setq TeX-auto-save t)
  (setq TeX-parse-self t)
  (setq-default TeX-master nil)

  ;; Use XeLaTeX by default
  (setq-default TeX-engine 'xetex)

  ;; Enable PDF mode by default
  (setq TeX-PDF-mode t)

  ;; Correlation between source and PDF
  (setq TeX-source-correlate-mode t)
  (setq TeX-source-correlate-start-server t)
  (setq TeX-source-correlate-method 'synctex)

  ;; Auto-save and parse on load
  (setq TeX-auto-save t)
  (setq TeX-parse-self t)

  ;; Don't ask for confirmation when saving
  (setq TeX-save-query nil)

  ;; Automatically insert braces after sub/superscript
  (setq TeX-electric-sub-and-superscript t)

  ;; Use hidden directories for build files
  (setq TeX-auto-local ".auctex-auto")
  (setq TeX-style-local ".auctex-style")

  ;; PDF viewer setup
  (setq TeX-view-program-selection '((output-pdf "PDF Tools"))
        TeX-view-program-list '(("PDF Tools" TeX-pdf-tools-sync-view))
        TeX-source-correlate-start-server t)

  ;; Update PDF buffers after successful LaTeX runs
  (add-hook 'TeX-after-compilation-finished-functions
            #'TeX-revert-document-buffer)

  ;; Enable folding
  (add-hook 'LaTeX-mode-hook #'TeX-fold-mode)

  ;; Enable math mode
  (add-hook 'LaTeX-mode-hook #'LaTeX-math-mode)

  ;; Enable outline minor mode
  (add-hook 'LaTeX-mode-hook #'outline-minor-mode))

;; RefTeX - Reference management
(use-package reftex
  :ensure t
  :after tex
  :hook (LaTeX-mode . turn-on-reftex)
  :config
  (setq reftex-plug-into-AUCTeX t)
  (setq reftex-bibliography-commands '("bibliography" "nobibliography" "addbibresource"))

  ;; Table of contents configuration
  (setq reftex-toc-split-windows-fraction 0.3)
  (setq reftex-toc-split-windows-horizontally t)

  ;; Enable auto-updating labels
  (setq reftex-enable-partial-scans t)
  (setq reftex-save-parse-info t)
  (setq reftex-use-multiple-selection-buffers t))

;; Company-AUCTeX - Autocompletion for LaTeX
(use-package company-auctex
  :ensure t
  :after (company auctex)
  :config
  (company-auctex-init))

;; Company - General autocompletion framework
(use-package company
  :ensure t
  :hook (after-init . global-company-mode)
  :config
  (setq company-idle-delay 0.2)
  (setq company-minimum-prefix-length 2)
  (setq company-selection-wrap-around t)

  ;; Better navigation in company popup
  (define-key company-active-map (kbd "C-n") #'company-select-next)
  (define-key company-active-map (kbd "C-p") #'company-select-previous))

;; Company-math - Math symbol completion
(use-package company-math
  :ensure t
  :after company
  :config
  (add-to-list 'company-backends 'company-math-symbols-unicode)
  (add-to-list 'company-backends 'company-latex-commands))

;; CDLaTeX - Fast input of LaTeX math
(use-package cdlatex
  :ensure t
  :hook ((LaTeX-mode . turn-on-cdlatex)
         (org-mode . turn-on-org-cdlatex))
  :config
  ;; Custom templates can be added here
  (setq cdlatex-math-symbol-alist
        '((?< ("\\leq" "\\ll" "\\langle"))
          (?> ("\\geq" "\\gg" "\\rangle"))
          (?= ("\\equiv" "\\approx" "\\simeq")))))

;; YASnippet - Snippet expansion
(use-package yasnippet
  :ensure t
  :hook (LaTeX-mode . yas-minor-mode)
  :config
  (yas-reload-all))

(use-package yasnippet-snippets
  :ensure t
  :after yasnippet)

;; Magic LaTeX Buffer - Prettify LaTeX buffer
(use-package magic-latex-buffer
  :ensure t
  :hook (LaTeX-mode . magic-latex-buffer)
  :config
  (setq magic-latex-enable-block-highlight t)
  (setq magic-latex-enable-suscript t)
  (setq magic-latex-enable-pretty-symbols t)
  (setq magic-latex-enable-block-align nil)
  (setq magic-latex-enable-inline-image t))

;; LaTeX-preview-pane - Live preview
(use-package latex-preview-pane
  :ensure t
  :config
  ;; Enable by default (you can toggle with M-x latex-preview-pane-mode)
  ;; (setq latex-preview-pane-multifile-mode 'auctex)
  )

;; Org-mode LaTeX export settings
(use-package ox-latex
  :ensure nil
  :after org
  :config
  (setq org-latex-create-formula-image-program 'dvipng)
  (setq org-latex-compiler "xelatex")

  ;; Add custom LaTeX classes if needed
  (add-to-list 'org-latex-classes
               '("article"
                 "\\documentclass[11pt]{article}"
                 ("\\section{%s}" . "\\section*{%s}")
                 ("\\subsection{%s}" . "\\subsection*{%s}")
                 ("\\subsubsection{%s}" . "\\subsubsection*{%s}")
                 ("\\paragraph{%s}" . "\\paragraph*{%s}")
                 ("\\subparagraph{%s}" . "\\subparagraph*{%s}"))))

;; PDF Tools - Superior PDF viewing
(use-package pdf-tools
  :ensure t
  :mode ("\\.pdf\\'" . pdf-view-mode)
  :config
  (pdf-tools-install :no-query)

  ;; Automatically revert PDF buffers when file changes
  (add-hook 'pdf-view-mode-hook #'auto-revert-mode)

  ;; More fine-grained zooming
  (setq pdf-view-resize-factor 1.1)

  ;; Keyboard hints
  (setq pdf-view-use-unicode-ligther nil))

;; ====================
;; Programming Languages
;; ====================

;; Python
(use-package elpy
  :ensure t
  :defer t
  :init
  (advice-add 'python-mode :before 'elpy-enable))

;; Rust
(use-package rust-mode
  :ensure t
  :hook ((rust-mode . (lambda ()
                        (setq indent-tabs-mode nil)
                        (prettify-symbols-mode)))
         (rust-mode . (lambda ()
                        (setq rust-format-on-save t)))))

(use-package cargo-mode
  :ensure t
  :hook (rust-mode . cargo-minor-mode))

;; ====================
;; Bibliography
;; ====================

(use-package citar
  :ensure t
  :custom
  (citar-bibliography '("~/bibliography/references.bib")))

(use-package citar-org-roam
  :ensure t
  :after (citar org-roam)
  :config
  (citar-org-roam-mode))

;; ====================
;; Spell Checking
;; ====================

(dolist (hook '(text-mode-hook))
  (add-hook hook (lambda () (flyspell-mode 1))))

;; ====================
;; Platform-Specific Settings
;; ====================

;; macOS settings
(when (eq system-type 'darwin)
  (setq mac-command-modifier 'meta
        mac-option-modifier 'alt
        mac-right-option-modifier 'alt))

;; X11 settings
(when (eq window-system 'x)
  (setq x-meta-keysym 'alt
        x-alt-keysym 'meta))

;; ====================
;; System Clipboard (Linux)
;; ====================

(use-package xclip
  :ensure t
  :if (and (eq system-type 'gnu/linux)
           (not (display-graphic-p)))
  :config
  (xclip-mode 1))

;; ====================
;; Custom Variables
;; ====================

(custom-set-variables
 ;; custom-set-variables was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 '(package-selected-packages
   '(ligature catppuccin-theme org-journal pdf-tools citar-org-roam citar
     elpy ace-window use-package org-roam xclip deft rust-mode cargo-mode
     auctex reftex company company-auctex company-math cdlatex yasnippet
     yasnippet-snippets magic-latex-buffer latex-preview-pane)))

(custom-set-faces
 ;; custom-set-faces was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 )

(provide 'init)
;;; init.el ends here
