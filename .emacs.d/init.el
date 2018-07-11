(require 'package)
(add-to-list 'package-archives '("melpa" . "https://melpa.org/packages/"))
(package-initialize)

;; Emacs' "custom" facility is honestly pretty abominable, and writes stuff to this
;; file on occasion (custom-set-variables, custom-set-faces) which clutters it and
;; results in extraneous diffs. This effectively disables "custom"
(setq custom-file (make-temp-file "emacs-custom"))

;; Some org-mode keybindings conflict with other builtin packages, namely windmove's
;; S-<arrow>s. This replaces them in org mode with something else.
;; It's set here instead of in conf.org b/c it needs to be set before org-mode, and
;; conf.org is--well, it's a .org file.
(setq org-replace-disputed-keys t)

(org-babel-load-file "~/.emacs.d/conf.org")
