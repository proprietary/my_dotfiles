(custom-set-variables
 ;; custom-set-variables was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 '(custom-safe-themes
   '("c7737b9fc3471779c8e51ea0a37834d24aa80a0d6a79b215e7501227ada39855" "f366d4bc6d14dcac2963d45df51956b2409a15b770ec2f6d730e73ce0ca5c8a7" default))
 '(package-selected-packages
   '(anti-zenburn-theme zenburn-theme bazel cmake-mode magit which-key dap-mode lsp-ui lsp-mode use-package)))
(custom-set-faces
 ;; custom-set-faces was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 )

;;
;; Meta Configuration / Packaging Stuff
;; ------------------------------------
;;

(add-to-list 'load-path (concat (file-name-as-directory user-emacs-directory) "lisp"))

;;; MELPA

(require 'package)
(add-to-list 'package-archives '("melpa" . "https://melpa.org/packages/") t)
;; Comment/uncomment this line to enable MELPA Stable if desired.  See `package-archive-priorities`
;; and `package-pinned-packages`. Most users will not need or want to do this.
;;(add-to-list 'package-archives '("melpa-stable" . "https://stable.melpa.org/packages/") t)
(package-initialize)

;;
;; MacOS
;; -----

(when (string-equal "darwin" system-type)
  (defun copy-from-osx ()
    (shell-command-to-string "pbpaste"))

  (defun paste-to-osx (text &optional push)
    (let ((process-connection-type nil))
      (let ((proc (start-process "pbcopy" "*Messages*" "pbcopy")))
	(process-send-string proc text)
	(process-send-eof proc))))

  (setq interprogram-cut-function 'paste-to-osx)
  (setq interprogram-paste-function 'copy-from-osx))


;;
;; Language Server Protocol
;; ------------------------
;;

(use-package lsp-mode
  :ensure t
  :init
  ;; set prefix for lsp-command-keymap (few alternatives - "C-l", "C-c l")
  (setq lsp-keymap-prefix "C-c l")
  :hook (;; replace XXX-mode with concrete major-mode(e. g. python-mode)
         (c++-mode . lsp)
	 (c-mode . lsp)
         ;; if you want which-key integration
         (lsp-mode . lsp-enable-which-key-integration))
  :commands lsp)

;; optionally
(use-package lsp-ui :ensure t :commands lsp-ui-mode)
;; if you are helm user
;(use-package helm-lsp :commands helm-lsp-workspace-symbol)
;; if you are ivy user
;(use-package lsp-ivy :commands lsp-ivy-workspace-symbol)
;(use-package lsp-treemacs :commands lsp-treemacs-errors-list)

;; optionally if you want to use debugger
(use-package dap-mode :ensure t)
;; (use-package dap-LANGUAGE) to load the dap adapter for your language

;; optional if you want which-key integration
(use-package which-key :ensure t :config (which-key-mode))

;;
;; Language-specific stuff
;; -----------------------
;;

;; C++
;; suppress namespace indentation
(defconst my-cc-style
  '("cc-mode"
    (c-offsets-alist . ((innamespace . [0])))))

(c-add-style "my-cc-mode" my-cc-style)

(defun c++-suppress-namespace-indentation ()
  (c-set-offset 'substatement-open 0)
  (c-set-offset 'innamespace 0))

(add-hook 'c-mode-common-hook #'c++-suppress-namespace-indentation)
(add-hook 'c++-mode-hook #'c++-suppress-namespace-indentation)

;;
;; Git
;; ---
;;
(use-package magit
  :ensure t
  :bind (("C-x g". magit-status) ("C-x C-g" . magit-status)))

;;
;; Navigation
;; ----------
;;

;; Interactively Do Things -- fast buffer switch
(require 'ido)
(ido-mode 'buffers) ;; only use this line to turn off ido for file names!
(setq ido-ignore-buffers '("^ " "*Completions*" "*Shell Command Output*"
               "*Messages*" "Async Shell Command"))

;; scroll smoothly one step at a time
(setq scroll-step 1
      scroll-conservatively 10000)

(global-hl-line-mode)

(setq backup-directory-alist
      `(("." . ,(concat user-emacs-directory "backups"))))

(load-theme 'manoj-dark t)
