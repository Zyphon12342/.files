;; =============================
;; BASIC UI CONFIGURATION
;; =============================

;; No startup message
(setq inhibit-startup-message t)

;; Keep *scratch* buffer with default initial message
(setq inhibit-startup-buffer-menu nil)

;; Disable toolbar, scrollbar, tooltip, dialogs
(menu-bar-mode -1)
(tool-bar-mode -1)
(scroll-bar-mode -1)
(tooltip-mode -1)
(setq use-dialog-box nil)
(setq visible-bell t)

;; Remove fringes
(fringe-mode 0)

;; Frame appearance: borderless fullscreen
(add-to-list 'default-frame-alist '(undecorated . t))
(add-to-list 'default-frame-alist '(fullscreen . fullboth))
(add-to-list 'default-frame-alist '(background-color . "#292D3E")) ;; match doom-palenight
(add-to-list 'default-frame-alist '(internal-border-width . 0))

;; Hide window dividers entirely
(setq window-divider-default-right-width 0)
(setq window-divider-default-bottom-width 0)
(window-divider-mode -1)

;; Line and column numbers
(global-display-line-numbers-mode t)
(setq display-line-numbers-type 'absolute)
(column-number-mode t)

;; Disable backups and auto-save
(setq make-backup-files nil)
(setq auto-save-default nil)

;; Clipboard integration and UTF-8
(setq select-enable-clipboard t)
(prefer-coding-system 'utf-8)

;; Set font
(set-face-attribute 'default nil :font "Fira Code Retina" :height 110)

;; =============================
;; PACKAGE MANAGEMENT
;; =============================
(require 'package)
(setq package-archives
      '(("melpa" . "https://melpa.org/packages/")
        ("gnu"   . "https://elpa.gnu.org/packages/")))
(package-initialize)
(unless package-archive-contents (package-refresh-contents))
(unless (package-installed-p 'use-package) (package-install 'use-package))
(require 'use-package)
(setq use-package-always-ensure t)

;; =============================
;; THEME
;; =============================
(use-package doom-themes
  :config
  (load-theme 'doom-palenight t)
  (doom-themes-visual-bell-config)
  (doom-themes-org-config))

;; =============================
;; SHELL CLEAR SHORTCUT
;; =============================
(defun my-comint-clear ()
  "Clear the entire shell buffer and send clear command to shell."
  (interactive)
  (let ((comint-buffer-maximum-size 0))
    (erase-buffer)
    (comint-send-input)))
(add-hook 'shell-mode-hook
          (lambda () (local-set-key (kbd "C-c l") #'my-comint-clear)))

;; =============================
;; GIT INTEGRATION
;; =============================
(use-package magit)
(use-package diff-hl :hook (prog-mode . diff-hl-mode))

;; =============================
;; LSP AND LANGUAGE SUPPORT
;; =============================
(use-package lsp-mode
  :commands lsp
  :init (setq lsp-keymap-prefix "C-c l")
  :config (lsp-enable-which-key-integration t))
(use-package lsp-ui :commands lsp-ui-mode)
(add-hook 'c-mode-common-hook #'lsp)
(add-hook 'java-mode-hook #'lsp)
(use-package rust-mode :hook (rust-mode . lsp))
(use-package cargo :hook (rust-mode . cargo-minor-mode))
(use-package python-mode :hook (python-mode . lsp))
(use-package js2-mode :mode "\\.js\\'" :hook (js2-mode . lsp))
(use-package dart-mode :hook (dart-mode . lsp))
(use-package lsp-dart :after (dart-mode lsp-mode) :hook (dart-mode . lsp))

;; =============================
;; COMPLETION & SYNTAX
;; =============================
(use-package company
  :hook (prog-mode . company-mode)
  :config
  (setq company-minimum-prefix-length 1
        company-idle-delay 0.0
        company-backends '(company-capf)))
(use-package flycheck :hook (prog-mode . flycheck-mode))
(electric-pair-mode 1)

;; =============================
;; PROJECTILE & TREE
;; =============================
(use-package projectile
  :init (projectile-mode +1)
  :config (setq projectile-project-search-path '("~/"))
  :bind-keymap ("C-c p" . projectile-command-map))
(use-package treemacs :defer t)
(use-package treemacs-projectile :after (treemacs projectile))

;; =============================
;; FINAL TOUCHES
;; =============================
(global-hl-line-mode -1)
(custom-set-variables
 '(package-selected-packages
   '(treemacs-projectile projectile lsp-dart diff-hl rust-mode python-mode
     magit lsp-ui js2-mode flycheck dart-mode company cargo doom-themes)))
(custom-set-faces)
