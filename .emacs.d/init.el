(require 'package)
(add-to-list 'package-archives '("melpa" . "https://melpa.org/packages/"))
(package-initialize)

;; Emacs' "custom" facility is honestly pretty abominable, and writes stuff to this
;; file on occasion (custom-set-variables, custom-set-faces) which clutters it and
;; results in extraneous diffs. This effectively disables "custom"
(setq custom-file (make-temp-file "emacs-custom"))

(org-babel-load-file "~/.emacs.d/conf.org")
