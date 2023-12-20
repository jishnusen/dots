;;; $DOOMDIR/config.el -*- lexical-binding: t; -*-

(setq doom-theme 'doom-tokyo-night
      doom-font (font-spec :family "Iosevka" :size 14))

;; This determines the style of line numbers in effect. If set to `nil', line
;; numbers are disabled. For relative line numbers, set this to `relative'.
(setq display-line-numbers-type t)

;; If you use `org' and don't want your org files in the default location below,
;; change `org-directory'. It must be set before org loads!
(setq org-directory "~/Documents/org/")

;;; ---keymaps --
(map! :g "C-x C-k" #'kill-this-buffer)

;;; -- Vi --
; disable recording macros (i'm too dumb for this feature i think)
(map! :n "q" nil)

;;; -- Init Vars ---
(add-to-list 'initial-frame-alist '(fullscreen . maximized))

(setq shell-file-name (executable-find "bash")
      conda-env-home-directory (expand-file-name "~/miniconda3/")
      ispell-personal-dictionary (concat doom-user-dir "misc/ispell_personal")
      yas-triggers-in-field t
      )


;;; -- Magit --
; fool magit into reading bare repos
(defun my/magit-process-environment (env)
  "Detect and set git -bare repo env vars when in tracked dotfile directories."
  (let* ((default (file-name-as-directory (expand-file-name default-directory)))
         (git-dir (expand-file-name "~/.dots/"))
         (work-tree (expand-file-name "~/"))
         (dotfile-dirs
          (-map (apply-partially 'concat work-tree)
                (-uniq (-keep #'file-name-directory (split-string (shell-command-to-string
                (format "/usr/bin/git --git-dir=%s --work-tree=%s ls-tree --full-tree --name-only -r HEAD"
                        git-dir work-tree))))))))
    (push work-tree dotfile-dirs)
    (when (member default dotfile-dirs)
      (push (format "GIT_WORK_TREE=%s" work-tree) env)
      (push (format "GIT_DIR=%s" git-dir) env)))
  env)

(advice-add 'magit-process-environment
            :filter-return #'my/magit-process-environment)


;;; -- Latex --
(setq TeX-save-query nil
      TeX-command-extra-options "-shell-escape")
(after! latex
  (add-to-list 'TeX-command-list '("XeLaTeX" "%`xelatex%(mode)%' %t" TeX-run-TeX nil t)))
(setq +latex-viewers '(pdf-tools evince zathura okular skim sumatrapdf)
      font-latex-fontify-script nil)

; stop autocomplete when i'm typing english
(add-hook 'LaTeX-mode-hook
      (lambda ()
        (make-local-variable 'line-move-visual)
        (setq-local company-minimum-prefix-length 5)))

; - auto insert math snips
; interactive snippet expand for use with AAS
(defun insnip (str)
  (lambda () (interactive) (yas-expand-snippet str)))

(use-package! laas
  :hook (LaTeX-mode . laas-mode)
  :config
  (aas-set-snippets 'laas-mode
                    :cond (lambda () (not (texmathp)))
                    "dm" (insnip "\\[\n$0\n\\]")
                    )
  )

;;; -- Common Lisp --
(after! common-lisp
 (setq sly-command-switch-to-existing-lisp 'never)
 )
