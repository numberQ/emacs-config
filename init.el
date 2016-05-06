(require 'package)

;; MELPA
(add-to-list 'package-archives '("melpa" . "https://melpa.org/packages/"))
(package-initialize)

;; Disable toolbar on startup
(tool-bar-mode -1)

;; Rebind C-z (from suspend to undo)
(require 'redo+)
(global-set-key (kbd "C-z") 'undo)
(global-set-key (kbd "C-M-z") 'redo)

;; Rebind C-v to yank and C-y to window scroll
(global-set-key (kbd "C-v") 'yank)
(global-set-key (kbd "C-y") 'scroll-up-command)

;; Helm
(add-to-list 'load-path "~/.emacs.d/helm")
(require 'helm-config)
(helm-mode 1)
(helm-flx-mode 1)

;; Set Helm key bindings
(global-set-key (kbd "M-x") 'helm-M-x)
(global-set-key (kbd "C-x C-f") 'helm-find-files)
(global-set-key (kbd "C-s") 'helm-swoop)

;; Company
(add-hook 'after-init-hook 'global-company-mode) ;; Enable globally
(add-hook 'company-mode-hook 'company-quickhelp-mode) ;; Enable quickhelp
(setq company-quickhelp-delay 0.5) ;; Set delay

;; Add .cljs.hl files as ClojureScript
(add-to-list 'auto-mode-alist '("\\.cljs\\.hl\\'" . clojurescript-mode))

;; Rainbow delimiters mode
(add-hook 'prog-mode-hook #'rainbow-delimiters-mode)

;; Custom themes location
(add-to-list 'custom-theme-load-path "~/.emacs.d/themes/")

;; Theme settings
(load-theme 'gandalf t) ;; Gandalf theme
(set-face-foreground 'font-lock-comment-face "saddle brown") ;; Comment color
(custom-set-faces ;; Rainbow delimiters colors
 '(rainbow-delimiters-depth-1-face ((t (:foreground "gray20"))))
 '(rainbow-delimiters-depth-2-face ((t (:foreground "brown"))))
 '(rainbow-delimiters-depth-3-face ((t (:foreground "royal blue"))))
 '(rainbow-delimiters-depth-4-face ((t (:foreground "dark magenta"))))
 '(rainbow-delimiters-depth-5-face ((t (:foreground "DarkGoldenrod4"))))
 '(rainbow-delimiters-depth-9-face ((t (:foreground "blue2"))))
 '(rainbow-delimiters-unmatched-face ((t (:background "red" :foreground "white"))))
 '(rainbow-delimiters-mismatched-face ((t (:background "red" :foreground "white")))))

;; Change appearance
(menu-bar-mode -1)
(scroll-bar-mode -1)
(global-linum-mode 1)

;; Reopen a file as root
(defun sudo-edit (&optional arg)
  "Edit currently visited file as root.

With a prefix ARG prompt for a file to visit.
Will also prompt for a file to visit if current
buffer is not visiting a file."
  (interactive "P")
  (if (or arg (not buffer-file-name))
      (find-file (concat "/sudo:root@localhost:"
                         (ido-read-file-name "Find file(as root): ")))
    (find-alternate-file (concat "/sudo:root@localhost:" buffer-file-name))))
(global-set-key (kbd "C-x C-r") 'sudo-edit)

;; Prompt before closing
(defun ask-before-closing ()
  "Ask whether or not to close, and then close if y was pressed"
  (interactive)
  (if (y-or-n-p (format "Are you sure you want to exit Emacs? "))
      (if (< emacs-major-version 22)
          (save-buffers-kill-terminal)
        (save-buffers-kill-emacs))
    (message "Canceled exit")))
(global-set-key (kbd "C-x C-c") 'ask-before-closing)
