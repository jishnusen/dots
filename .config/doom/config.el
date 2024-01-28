;; -*- lexical-binding: t -*-
(setq doom-theme 'doom-earl-grey
      doom-font (font-spec :family "Iosevka" :size 14)
      doom-variable-pitch-font (font-spec :family "ETbb" :size 14))

(add-to-list 'initial-frame-alist '(fullscreen . maximized))
(setq shell-file-name (executable-find "bash")
      conda-env-home-directory (expand-file-name "~/miniconda3/")
      yas-triggers-in-field t
      )
(add-hook 'text-mode-hook #'auto-fill-mode)

;; This determines the style of line numbers in effect. If set to `nil', line
;; numbers are disabled. For relative line numbers, set this to `relative'.
(setq display-line-numbers-type nil)

(setq org-directory "~/Documents/org/")

(map! :g "C-x C-k" #'kill-this-buffer)

;; disable recording macros (i'm too dumb for this feature i think)
(map! :n "q" nil)

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

(setq TeX-save-query nil
      TeX-command-extra-options "-shell-escape")
(after! latex
  (add-to-list 'TeX-command-list '("XeLaTeX" "%`xelatex%(mode)%' %t" TeX-run-TeX nil t))
  )
(setq +latex-viewers '(pdf-tools evince zathura okular skim sumatrapdf)
      font-latex-fontify-script nil
      font-latex-fontify-sectioning 1.0
      )
(defun prettify-setup ()
  ;; pretty unicodisms that arent default
  (push '("\\implies" . "⟹") prettify-symbols-alist)
  (push '("\\impliedby" . "⟸") prettify-symbols-alist)
  (push '("\\land" . "∧") prettify-symbols-alist)
  (push '("\\lor" . "∨") prettify-symbols-alist)
  (push '("\\dots" . 8230) prettify-symbols-alist)
  (push (cons "\\textdegree{}" (cdr (assoc "\\textdegree" prettify-symbols-alist))) prettify-symbols-alist)
  (push (cons "\\Z" (cdr (assoc "\\mathbb{Z}" prettify-symbols-alist))) prettify-symbols-alist)
  (push (cons "\\N" (cdr (assoc "\\mathbb{N}" prettify-symbols-alist))) prettify-symbols-alist)
  (push (cons "\\R" (cdr (assoc "\\mathbb{R}" prettify-symbols-alist))) prettify-symbols-alist)
  (push (cons "\\Q" (cdr (assoc "\\mathbb{Q}" prettify-symbols-alist))) prettify-symbols-alist)
  (dotimes (l 26)
    ;; mathcal -> bold italic starting from A
    (add-to-list 'prettify-symbols-alist (cons (concat "\\mathcal{" (byte-to-string (+ ?A l)) "}") (+ 120380 l))))
  (prettify-symbols-mode t)
  )

(add-hook 'LaTeX-mode-hook
          (lambda ()
            (make-local-variable 'line-move-visual)
            ;; stop autocomplete when i'm typing english
            (setq-local company-minimum-prefix-length 5)
            ;; reload file local from template
            (setq TeX-insert-macro-default-style 'mandatory-args-only)
            (prettify-setup)
            ))

(defun insnip (str)
  (lambda () (interactive) (yas-expand-snippet str)))

(use-package! laas
  :hook (LaTeX-mode . laas-mode)
  :config
  (setq laas-enable-auto-space nil)
  (aas-set-snippets 'laas-mode
    :cond (lambda () (not (laas-mathp)))
    "dm" (insnip "\\[\n$0\n\\]")
    "aln" (insnip "\\begin{align*}\n`%`$0\n\\end{align*}")
    "pf" (insnip "\\begin{proof}\n`%`$0\n\\end{proof}")
    )
  (aas-set-snippets 'laas-mode
    :cond (lambda () (laas-mathp))
    "'o" (lambda () (interactive) (laas-wrap-previous-object "mathbb"))
    )
  )

(after! spell-fu
  (setq ispell-program-name "hunspell"
        ispell-personal-dictionary (concat doom-user-dir "misc/ispell_personal")
        )
  (cl-pushnew 'font-lock-constant-face (alist-get 'latex-mode +spell-excluded-faces-alist))
  (ispell-check-version) ;; hack, apparently this makes ispell set its vars correctly
  )

(use-package! pdf-tools
  :defer t
  :config
  (setq pdf-sync-backward-display-action t)
  (setq pdf-sync-forward-display-action t)
  (setq-default pdf-view-display-size 'fit-page)
  )

(after! common-lisp
  (setq sly-command-switch-to-existing-lisp 'never)
  )

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

  (org-eldoc-load)
  )

(defun insert-snippet-abbr (abbr)
  "Insert the snippet abbreviated to abbr"
  (progn
    (insert abbr)
    (call-interactively 'yas-expand)))

(defun ask-light ()
  "Use Preamble or preamble_light."
  (if (y-or-n-p "insert light preamble?")
      (insert-snippet-abbr "__light")
      (insert-snippet-abbr "__")
      )
  )

(set-file-template! "\\.tex$" :trigger #'ask-light :mode 'latex-mode)
(set-file-template! "\\.org$" :trigger "__" :mode 'org-mode)
(set-file-template! "/LICEN[CS]E$" :trigger '+file-templates/insert-license)

(defun +yas/org-src-header-p ()
  "Determine whether `point' is within a src-block header or header-args."
  (pcase (org-element-type (org-element-context))
    ('src-block (< (point) ; before code part of the src-block
                   (save-excursion (goto-char (org-element-property :begin (org-element-context)))
                                   (forward-line 1)
                                   (point))))
    ('inline-src-block (< (point) ; before code part of the inline-src-block
                          (save-excursion (goto-char (org-element-property :begin (org-element-context)))
                                          (search-forward "]{")
                                          (point))))
    ('keyword (string-match-p "^header-args" (org-element-property :value (org-element-context))))))
(defun +yas/org-prompt-header-arg (arg question values)
  "Prompt the user to set ARG header property to one of VALUES with QUESTION.
The default value is identified and indicated. If either default is selected,
or no selection is made: nil is returned."
  (let* ((src-block-p (not (looking-back "^#\\+property:[ \t]+header-args:.*" (line-beginning-position))))
         (default
           (or
            (cdr (assoc arg
                        (if src-block-p
                            (nth 2 (org-babel-get-src-block-info t))
                          (org-babel-merge-params
                           org-babel-default-header-args
                           (let ((lang-headers
                                  (intern (concat "org-babel-default-header-args:"
                                                  (+yas/org-src-lang)))))
                             (when (boundp lang-headers) (eval lang-headers t)))))))
            ""))
         default-value)
    (setq values (mapcar
                  (lambda (value)
                    (if (string-match-p (regexp-quote value) default)
                        (setq default-value
                              (concat value " "
                                      (propertize "(default)" 'face 'font-lock-doc-face)))
                      value))
                  values))
    (let ((selection (consult--read values :prompt question :default default-value)))
      (unless (or (string-match-p "(default)$" selection)
                  (string= "" selection))
        selection))))
(defun +yas/org-src-lang ()
  "Try to find the current language of the src/header at `point'.
Return nil otherwise."
  (let ((context (org-element-context)))
    (pcase (org-element-type context)
      ('src-block (org-element-property :language context))
      ('inline-src-block (org-element-property :language context))
      ('keyword (when (string-match "^header-args:\\([^ ]+\\)" (org-element-property :value context))
                  (match-string 1 (org-element-property :value context)))))))

(defun +yas/org-last-src-lang ()
  "Return the language of the last src-block, if it exists."
  (save-excursion
    (beginning-of-line)
    (when (re-search-backward "^[ \t]*#\\+begin_src" nil t)
      (org-element-property :language (org-element-context)))))

(defun +yas/org-most-common-no-property-lang ()
  "Find the lang with the most source blocks that has no global header-args, else nil."
  (let (src-langs header-langs)
    (save-excursion
      (goto-char (point-min))
      (while (re-search-forward "^[ \t]*#\\+begin_src" nil t)
        (push (+yas/org-src-lang) src-langs))
      (goto-char (point-min))
      (while (re-search-forward "^[ \t]*#\\+property: +header-args" nil t)
        (push (+yas/org-src-lang) header-langs)))

    (setq src-langs
          (mapcar #'car
                  ;; sort alist by frequency (desc.)
                  (sort
                   ;; generate alist with form (value . frequency)
                   (cl-loop for (n . m) in (seq-group-by #'identity src-langs)
                            collect (cons n (length m)))
                   (lambda (a b) (> (cdr a) (cdr b))))))

    (car (cl-set-difference src-langs header-langs :test #'string=))))

(cl-loop for file in '("/usr/local/bin/fish" "/usr/bin/fish")
         when (file-exists-p file)
         do (progn
              (setq vterm-shell file)
              (cl-return)))

(use-package! elcord
  :commands elcord-mode
  :config
  (setq elcord-use-major-mode-as-main-icon t))
