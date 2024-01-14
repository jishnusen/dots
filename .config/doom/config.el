;;; $DOOMDIR/config.el -*- lexical-binding: t; -*-

(setq doom-theme 'doom-one-light
      doom-font (font-spec :family "Iosevka" :size 14)
      doom-variable-pitch-font (font-spec :family "ETbb" :size 14))

;; This determines the style of line numbers in effect. If set to `nil', line
;; numbers are disabled. For relative line numbers, set this to `relative'.
(setq display-line-numbers-type nil)

;; If you use `org' and don't want your org files in the default location below,
;; change `org-directory'. It must be set before org loads!
(setq org-directory "~/Documents/org/")

;;; ---keymaps --
(map! :g "C-x C-k" #'kill-this-buffer)

;;; -- Vi --
;; disable recording macros (i'm too dumb for this feature i think)
(map! :n "q" nil)

;;; -- Init Vars ---
(add-to-list 'initial-frame-alist '(fullscreen . maximized))

(setq shell-file-name (executable-find "bash")
      conda-env-home-directory (expand-file-name "~/miniconda3/")
      ispell-personal-dictionary (concat doom-user-dir "misc/ispell_personal")
      yas-triggers-in-field t
      )
(after! spell-fu
  (setq ispell-program-name "hunspell")
  (ispell-check-version) ;; hack, apparently this makes ispell set its vars correctly
  )

;;; -- Magit --
;; fool magit into reading bare repos
(defun my/magit-process-environment (env)
  "Detect and set git -bare repo env vars when in tracked dotfile directories."
  (let* ((default (file-name-as-directory (expand-file-name default-directory)))
         (git-dir (expand-file-name "~/.dots/"))
         (work-tree (expand-file-name "~/"))
         (dotfile-dirs
          (-map (apply-partially 'concat work-tree)
                (-uniq (-keep #'file-name-directory
                              (split-string
                               (shell-command-to-string
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
  (add-to-list 'TeX-command-list '("XeLaTeX" "%`xelatex%(mode)%' %t" TeX-run-TeX nil t))
  )
(setq +latex-viewers '(pdf-tools evince zathura okular skim sumatrapdf)
      font-latex-fontify-script nil
      font-latex-fontify-sectioning 1.0
      )

(add-hook 'LaTeX-mode-hook
          (lambda ()
            (make-local-variable 'line-move-visual)
            ;; stop autocomplete when i'm typing english
            (setq-local company-minimum-prefix-length 5)
            ;; pretty unicodisms that arent default
            (push '("\\implies" . "⟹") prettify-symbols-alist)
            (push '("\\impliedby" . "⟸") prettify-symbols-alist)
            (push '("\\land" . "∧") prettify-symbols-alist)
            (push '("\\lor" . "∨") prettify-symbols-alist)
            (push (cons "\\textdegree{}" (cdr (assoc "\\textdegree" prettify-symbols-alist))) prettify-symbols-alist)
            (prettify-symbols-mode t)
            ))

;; - auto insert math snips
;; interactive snippet expand for use with AAS
(defun insnip (str)
  (lambda () (interactive) (yas-expand-snippet str)))

(use-package! laas
  :hook (LaTeX-mode . laas-mode)
  :config
  (aas-set-snippets 'laas-mode
    :cond (lambda () (not (texmathp)))
    "dm" (insnip "\\[\n$0\n\\]")
    "aln" (insnip "\\begin{align*}\n\t$0\n\\end{align*}")
    "pf" (insnip "\\begin{proof}\n$0\n\\end{proof}")
    )
  )

;;; -- Common Lisp --
(after! common-lisp
  (setq sly-command-switch-to-existing-lisp 'never)
  )

;;; -- Org --
(after! org
  (setq org-highlight-latex-and-related '(native script entities))
  (add-to-list 'org-src-lang-modes '("latex-macros" . latex))

  (defvar org-babel-default-header-args:latex-macros
    '((:results . "raw")
      (:exports . "results")))

  (defun prefix-all-lines (pre body)
    (with-temp-buffer
      (insert body)
      (string-insert-rectangle (point-min) (point-max) pre)
      (buffer-string)))

  (defun org-babel-execute:latex-macros (body _params)
    (concat
     (prefix-all-lines "#+LATEX_HEADER: " body)
     "\n#+HTML_HEAD_EXTRA: <div style=\"display: none\"> \\(\n"
     (prefix-all-lines "#+HTML_HEAD_EXTRA: " body)
     "\n#+HTML_HEAD_EXTRA: \\)</div>\n"))
  )

;;; YASnippet
(set-file-template! "\\.tex$" :trigger "__" :mode 'latex-mode)
(set-file-template! "\\.org$" :trigger "__" :mode 'org-mode)
(set-file-template! "/LICEN[CS]E$" :trigger '+file-templates/insert-license)

;; From https://blog.florianschroedl.com/org-mode-src-snippet-with-automatic-language-attribute
(defun +yas/org-src-lang ()
  "Find the current language of the src/header at point || nil"
  (save-excursion
    (pcase
        (downcase
         (buffer-substring-no-properties
          (goto-char (line-beginning-position))
          (or (ignore-errors (1- (search-forward " " (line-end-position))))
              (1+ (point)))))
      ("#+property:"
       (when (re-search-forward "header-args:")
         (buffer-substring-no-properties
          (point)
          (or (and (forward-symbol 1) (point))
              (1+ (point))))))
      ("#+begin_src"
       (buffer-substring-no-properties
        (point)
        (or (and (forward-symbol 1) (point))
            (1+ (point)))))
      ("#+header:"
       (search-forward "#+begin_src")
       (+yas/org-src-lang))
      (_ nil))))

(defun +yas/org-last-src-lang ()
  (save-excursion
    (beginning-of-line)
    (when (search-backward "#+begin_src" nil t)
      (+yas/org-src-lang))))
