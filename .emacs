;; Basic .emacs with a good set of defaults, to be used as template for usage
;; with OCaml and OPAM
;;
;; Author: Louis Gesbert <louis.gesbert@ocamlpro.com>
;; Released under CC0

;; Generic, recommended configuration options
;;(require 'use-package)

(setq package-list '(use-package))

(require 'package)
   (package-initialize)
   (setq package-archives '(("gnu" ."https://elpa.gnu.org/packages/")
                        ("marmalade" . "https://marmalade-repo.org/packages/")
                        ("melpa" . "http://melpa.org/packages/")
                        ("org" . "http://orgmode.org/elpa/")))

;; Set default Python version to python3
(setq python-shell-interpreter "python3")

;; ivy-mode
(use-package ivy :ensure t :diminish ivy-mode
  :config
  (ivy-mode 1))

;; ipython notebooks
(require 'ein)

;; integrate pyenv with emacs
(require 'pyenv-mode-auto)


(setq inhibit-startup-message t)
(tooltip-mode -1)
(line-number-mode 1)
(global-linum-mode 1)
(column-number-mode 1)
(setq scroll-margin 0
      scroll-preserve-screen-position 1
      scroll-step 1
      scroll-conservatively 10000)
(show-paren-mode 1)

(fset 'yes-or-no-p 'y-or-n-p)

(require 'uniquify)
(global-hl-line-mode 1) ; highlights current line
;(set-face-background hl-line-face "#111")

(global-visual-line-mode 1)
(global-font-lock-mode 1)
(which-function-mode t)
(setq ring-bell-function 'ignore)

(use-package molokai-theme :ensure t)
(set-face-foreground 'font-lock-comment-face "light green")

(custom-set-variables
 ;; custom-set-variables was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 '(ac-use-fuzzy nil)
 '(backup-directory-alist (quote (("." . "~/.local/share/emacs/backups"))))
 '(compilation-context-lines 2)
 '(compilation-error-screen-columns nil)
 '(compilation-scroll-output t)
 '(compilation-search-path (quote (nil "src")))
 '(electric-indent-mode nil)
 '(indent-tabs-mode nil)
 '(inhibit-startup-screen t)
 '(line-move-visual t)
 '(next-error-highlight t)
 '(next-error-highlight-no-select t)
 '(next-line-add-newlines nil)
 '(require-final-newline t)
 '(sentence-end-double-space nil)
 '(show-paren-mode t)
 '(show-trailing-whitespace t)
 '(visible-bell t))

;; ANSI color in compilation buffer
(require 'ansi-color)
(defun colorize-compilation-buffer ()
  (toggle-read-only)
  (ansi-color-apply-on-region (point-min) (point-max))
  (toggle-read-only))
(add-hook 'compilation-filter-hook 'colorize-compilation-buffer)

;; Some key bindings

(global-set-key [f3] 'next-match)
(defun prev-match () (interactive nil) (next-match -1))
(global-set-key [(shift f3)] 'prev-match)
(global-set-key [backtab] 'auto-complete)
;; OCaml configuration
;;  - better error and backtrace matching

(defun set-ocaml-error-regexp ()
  (set
   'compilation-error-regexp-alist
   (list '("[Ff]ile \\(\"\\(.*?\\)\", line \\(-?[0-9]+\\)\\(, characters \\(-?[0-9]+\\)-\\([0-9]+\\)\\)?\\)\\(:\n\\(\\(Warning .*?\\)\\|\\(Error\\)\\):\\)?"
    2 3 (5 . 6) (9 . 11) 1 (8 compilation-message-face)))))
 
(add-hook 'tuareg-mode-hook 'set-ocaml-error-regexp)
(add-hook 'caml-mode-hook 'set-ocaml-error-regexp)
;; ## added by OPAM user-setup for emacs / base ## 56ab50dc8996d2bb95e7856a6eddb17b ## you can edit, but keep this line
(require 'opam-user-setup "~/.emacs.d/opam-user-setup.el")
;; ## end of OPAM user-setup addition for emacs / base ## keep this line
;; Add MELPA support (needed to install company and tuareg)
(require 'package)
(add-to-list 'package-archives '("melpa" . "https://melpa.org/packages/"))
(package-initialize)
;; Tell company about Merlin
(with-eval-after-load 'company (add-to-list 'company-backends 'merlin-company-backend))
;; Company anywhere
(add-hook 'after-init-hook 'global-company-mode)
(custom-set-faces
 ;; custom-set-faces was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 )
