;; NOTE: init.el is now generated from Emacs.org.  Please edit that file
;; in Emacs and init.el will be generated automatically!
;; teste

;;________ {Configuraçoes gerais} ________;;
(menu-bar-mode -1)
(scroll-bar-mode -1)
(tool-bar-mode -1)
(tooltip-mode -1)
(column-number-mode)
(global-display-line-numbers-mode t)
(setq inhibit-startup-message t)
(setq initial-scratch-message nil)
(setq next-line-add-newlines nil)
(defalias 'yes-or-no-p 'y-or-n-p)
(setq use-dialog-box nil)

;; Edição de texto e autocomplete
(setq font-lock-maximum-decoration t)
(setq evil-want-keybinding nil)
(setq show-paren-style 'expression)
(setq completion-ignore-case t)
(setq read-buffer-completion-ignore-case t)
(setq read-file-name-completion-ignore-case t)
(setq indent-tabs-mode t)
(setq tab-width 2)
(setq-default cursor-type 'bar)
(blink-cursor-mode 1)
(global-auto-revert-mode 1)
(global-font-lock-mode t)
(show-paren-mode t)

;; Improve scrolling.
(setq mouse-wheel-scroll-amount '(1 ((shift) . 1)))
(setq mouse-wheel-progressive-speed nil)
(setq mouse-wheel-follow-mouse 't)
(setq scroll-step 1)

;; UTF-8
(prefer-coding-system 'utf-8)
(set-language-environment "UTF-8")
(setq locale-coding-system 'utf-8)
(set-selection-coding-system 'utf-8)
(setq-default buffer-file-coding-system 'utf-8-unix)

;; Ativar arquivo recentes
(recentf-mode 1)
;; Navegar entre os mini buffers do Emacs
;; M-n e M-p
(setq history-length 25)
(savehist-mode 1)
(save-place-mode 1)

;; Backups aqui
;; New location for backups.
(setq backup-directory-alist '(("." . "~/.emacs.d/backups")))
;; Silently delete execess backup versions
(setq delete-old-versions t)
;; Only keep the last 1000 backups of a file.
(setq kept-old-versions 1000)
;; Even version controlled files get to be backed up.
(setq vc-make-backup-files t)
;; Use version numbers for backup files.
(setq version-control t)
;; remover a mensagem de erro
;; ad-handle-definition: ‘hippie-expand’ got redefined
(setq ad-redefinition-action 'accept)
;; Make Emacs backup everytime I save
(defun my/force-backup-of-buffer ()
  "Lie to Emacs, telling it the curent buffer has yet to be backed up."
  (setq buffer-backed-up nil))
(add-hook 'before-save-hook  'my/force-backup-of-buffer)
;; [Default settings]
;; Autosave when idle for 30sec or 300 input events performed
(setq auto-save-timeout 30
      auto-save-interval 300)

; ;; Make frame transparency overridable
(defvar efs/frame-transparency '(90 . 90))

;; Set frame transparency
(set-frame-parameter (selected-frame) 'alpha efs/frame-transparency)
(add-to-list 'default-frame-alist `(alpha . ,efs/frame-transparency))
(set-frame-parameter (selected-frame) 'fullscreen 'maximized)
(add-to-list 'default-frame-alist '(fullscreen . maximized))


;;________ {Straight} ________;;
(custom-set-variables
 '(straight-repository-branch "develop")
 '(straight-check-for-modifications '(check-on-save find-when-checking))
 '(straight-use-package-by-default t)
 '(straight-vc-git-default-clone-depth 1))

(defvar bootstrap-version)
(let ((bootstrap-file
       (expand-file-name "straight/repos/straight.el/bootstrap.el" user-emacs-directory))
      (bootstrap-version 5))
  (unless (file-exists-p bootstrap-file)
    (with-current-buffer
        (url-retrieve-synchronously
         "https://raw.githubusercontent.com/raxod502/straight.el/develop/install.el"
         'silent 'inhibit-cookies)
      (goto-char (point-max))
      (eval-print-last-sexp)))
  (load bootstrap-file nil 'nomessage))

(autoload #'straight-x-clean-unused-repos "straight-x" nil t)
(autoload #'straight-x-fetch-all "straight-x" nil t)

(defvar straight--repo-cache)
(defun straight-x-delete-package (name)
  "Prompt for package NAME and delete it from the file system."
  (interactive (list (completing-read "Delete package: " (hash-table-keys straight--repo-cache))))
  (let* ((repo (plist-get (gethash name straight--repo-cache) :local-repo))
         (eln-dirs (cl-loop for dir in native-comp-eln-load-path append
                            (directory-files dir t "[^.].*")))
         (modules (mapcar #'file-name-sans-extension
                          (directory-files (straight--repos-dir repo) nil ".*\\.el")))
         (files (cl-loop for dir in eln-dirs append
                         (directory-files dir t (format "%s-[0-9a-f]\\{32\\}-[0-9a-f]\\{32\\}\\.eln"
                                                        (regexp-opt modules)))))
         (dirs (list (straight--repos-dir repo) (straight--build-dir repo))))
    (when (yes-or-no-p (format "Delete these files and directories?\n%s\n "
                               (mapconcat #'identity (append dirs files) "\n")))
      (dolist (dir dirs)
        (delete-directory dir 'recursive 'trash)
        (message "Deleted directory %s" dir))
      (dolist (file files)
        (delete-file file 'trash)
        (message "Deleted file %s." file)))))

;; use-package
(straight-use-package 'use-package)
(require 'use-package)
(when init-file-debug
  (setq use-package-verbose t
        use-package-expand-minimally nil
        use-package-compute-statistics t
        debug-on-error t))


;;________ {Melpa} ________;;
(require 'package)
(setq package-archives '( ("gnu" . "http://elpa.gnu.org/packages/")
                          ("elpa" . "http://tromey.com/elpa/")
                          ("melpa" . "http://melpa.org/packages/")
                          ("org" . "https://orgmode.org/elpa/"))
      tls-checktrust t
      tls-program '("gnutls-cli --x509cafile %t -p %p %h")
      gnutls-verify-error t)

(when (not (package-installed-p 'use-package))
  (package-refresh-contents)
  (package-install 'use-package))
(setq use-package-always-ensure t)


;;________ {Packages Aqui} ________;;
;; (use-package benchmark-init
;;   :config
;;   ;; To disable collection of benchmark data after init is done.
;;   ;; (add-hook 'after-init-hook 'benchmark-init/deactivate))
;;   (add-hook 'after-init-hook
;;             (lambda () (message "loaded in %s" (emacs-init-time))))



(use-package benchmark-init
  ;; complains error with 'void function benchmark-init/activate'
  ;; when first run just after install, if use init.
  :defer nil
  :config
  (require 'benchmark-init)
  (benchmark-init/activate)
  :hook
  ;; To disable collection of benchmark data after init is done.
  (after-init . benchmark-init/deactivate))

(defalias 'y/profile-tabulated 'benchmark-init/show-durations-tabulated
  "Profiling emacs startup time. Show result as a table.")
(defalias 'y/profile-tree 'benchmark-init/show-durations-tree
  "Profiling emacs startup time. Show result as a tree.")



;; Common libraries that are effectively part of the Emacs core library because
(use-package dash :demand t)
(use-package s :demand t)
(use-package f :demand t)
(use-package async
  :hook
  (dired-mode-hook . dired-async-mode))

;;________ {UI} ________;;
(setq default-frame-alist
      (append (list '(width  . 72) '(height . 40)
                    '(vertical-scroll-bars . nil)
                    '(internal-border-width . 24)
                    '(font . "Fira Code 13")
                    )))
(set-frame-parameter (selected-frame)
                     'internal-border-width 24)
(setq window-divider-default-right-width 3)
(setq window-divider-default-places 'right-only)
(window-divider-mode)

(use-package dracula-theme
  :config (load-theme 'dracula t))

;; (use-package chocolate-theme
;;   :config (load-theme 'chocolate t))

;; (use-package apropospriate-theme
;;   :ensure t
;;   :config
;;   (load-theme 'apropospriate-dark t))
;; ;;   ;; or
  ;; (load-theme 'apropospriate-light t))

(use-package all-the-icons
  :if (display-graphic-p))

(use-package spaceline
  :init
  (setq-default powerline-image-apple-rgb nil)
	(setq powerline-height 24
        spaceline-highlight-face-func 'spaceline-highlight-face-evil-state
        powerline-default-separator 'arrow)
	(setq-default spaceline-window-numbers-unicode t)
  (setq-default spaceline-minor-modes-separator " ")
  (require 'spaceline-config)
  :config
  (spaceline-spacemacs-theme)
  (spaceline-toggle-buffer-size-off)
  (spaceline-toggle-hud-off)

  (spaceline-toggle-minor-modes-off)
  (spaceline-toggle-buffer-modified-off)

  ;; (spaceline-toggle-buffer-id-off)
  (spaceline-toggle-major-mode-off)
  ;; (spaceline-toggle-process-off)
  ;; (spaceline-toggle-version-control-off)
  (spaceline-toggle-buffer-encoding-off)
  (spaceline-toggle-buffer-encoding-abbrev-off)
  ;; (spaceline-toggle-point-position-off)
  ;; (spaceline-toggle-line-off)
  ;; (spaceline-toggle-column-off)
  ;; (spaceline-toggle-line-column-off)
  (spaceline-toggle-buffer-position-off)
  ;; (spaceline-toggle-selection-info-off)
  ;; (spaceline-toggle-input-method-off)
  )
;; types are: 'slant, 'arrow, 'cup, 'wave, 'none, 'nil

;; Comment if you want to keep the modeline at the bottom
(setq-default header-line-format mode-line-format)
(setq-default mode-line-format nil)

(use-package all-the-icons-dired
  :if (display-graphic-p)
  :config
  :hook (dired-mode . (lambda ()
                       (interactive)
                       (unless (file-remote-p default-directory)
                         (all-the-icons-dired-mode)))))

;;________ {Uso do terminal dentro do Emacs} ________;;
(use-package vterm
  :config
  (defun turn-off-chrome ()
    (hl-line-mode -1)
    (display-line-numbers-mode -1))
  :hook (vterm-mode . turn-off-chrome))

(use-package vterm-toggle
  :custom
  (vterm-toggle-fullscreen-p nil "Open a vterm in another window.")
  (vterm-toggle-scope 'project)
  :bind (("C-c t" . #'vterm-toggle)
         :map vterm-mode-map
         ("C-\\" . #'popper-cycle)
         ("s-t" . #'vterm) ; Open up new tabs quickly
         ("s-v" . #'vterm-yank)))


;;________ {Cores} ________;;
(use-package window-highlight
  :if (and window-system
           (>= emacs-major-version 27)
           (not (eq window-system 'windows-nt)))
  :demand t
  :straight (window-highlight :host github :repo "dcolascione/emacs-window-highlight")
  :config
  (set-frame-parameter (selected-frame) 'last-focus-update t)
  (window-highlight-mode))

(use-package highlight-numbers
  :commands highlight-numbers-mode)

(use-package rainbow-identifiers
  :commands rainbow-identifiers-mode)

(use-package rainbow-delimiters
  :commands rainbow-delimiters-mode
  :hook(
    (prog-mode . rainbow-delimiters-mode)
    (text-mode . rainbow-delimiters-mode)))

(use-package rainbow-mode
  :commands rainbow-mode
  :diminish
  :hook ((web-mode-hook
          css-mode-hook
          emacs-lisp-mode-hook
          js-mode-hook
          sass-mode-hook)
          . rainbow-mode))

(use-package highlight-parentheses
  :config
  (show-paren-mode t)
  (setq show-paren-style 'mixed)
  '(kept-old-versions 0)
  (setq show-paren-delay 0))

(use-package color-identifiers-mode
  :init
  (add-hook 'after-init-hook 'global-color-identifiers-mode))

(use-package highlight-thing
  :if (display-graphic-p)
  :hook
  (prog-mode . highlight-thing-mode))

(use-package highlight-indent-guides
  :init
  (setq highlight-indent-guides-character ?‖)
  :custom
    (highlight-indent-guides-auto-enabled t)
    (highlight-indent-guides-responsive t)
    (highlight-indent-guides-method 'character)
  :hook
    (prog-mode  . highlight-indent-guides-mode))

(use-package volatile-highlights
  :config
  (volatile-highlights-mode t))

(use-package info-colors
  :hook
  (Info-selection-hook . info-colors-fontify-node))

(use-package beacon
  :init
    (beacon-mode 1)
  :config
    ;; only flash on window/buffer changes...
    (setq beacon-blink-when-window-changes t)
    (setq beacon-blink-when-window-scrolls nil)
    (setq beacon-blink-when-point-moves nil)
    (setq beacon-blink-duration .2)
    (setq beacon-blink-delay .2)
    (setq beacon-size 20))


;;________ {Dired} ________;;
(use-package dired-rainbow
  :defer 4
  :config
  (dired-rainbow-define-chmod directory "#0074d9" "d.*")
  (dired-rainbow-define html "#eb5286"
                        ("css" "less" "sass" "scss" "htm" "html" "jhtm" "mht"
                         "eml" "mustache" "xhtml"))
  (dired-rainbow-define xml "#f2d024"
                        ("xml" "xsd" "xsl" "xslt" "wsdl" "bib" "json" "msg"
                         "pgn" "rss" "yaml" "yml" "rdata" "sln" "csproj"
                         "meta" "unity" "tres" "tscn" "import" "godot"))
  (dired-rainbow-define document "#9561e2"
                        ("docm" "doc" "docx" "odb" "odt" "pdb" "pdf" "ps"
                         "rtf" "djvu" "epub" "odp" "ppt" "pptx" "xls" "xlsx"
                         "vsd" "vsdx" "plantuml"))
  (dired-rainbow-define markdown "#4dc0b5"
                        ("org" "org_archive" "etx" "info" "markdown" "md"
                         "mkd" "nfo" "pod" "rst" "tex" "texi" "textfile" "txt"))
  (dired-rainbow-define database "#6574cd"
                        ("xlsx" "xls" "csv" "accdb" "db" "mdb" "sqlite" "nc"))
  (dired-rainbow-define media "#de751f"
                        ("mp3" "mp4" "MP3" "MP4" "avi" "mpeg" "mpg" "flv"
                         "ogg" "mov" "mid" "midi" "wav" "aiff" "flac" "mkv"))
  (dired-rainbow-define image "#f66d9b"
                        ("tiff" "tif" "cdr" "gif" "ico" "jpeg" "jpg" "png"
                         "psd" "eps" "svg"))
  (dired-rainbow-define log "#c17d11"
                        ("log" "log.1" "log.2" "log.3" "log.4" "log.5" "log.6"
                         "log.7" "log.8" "log.9"))
  (dired-rainbow-define shell "#f6993f"
                        ("awk" "bash" "bat" "fish" "sed" "sh" "zsh" "vim"))
  (dired-rainbow-define interpreted "#38c172"
                        ("py" "ipynb" "hy" "rb" "pl" "t" "msql" "mysql"
                         "pgsql" "sql" "r" "clj" "cljs" "cljc" "cljx" "edn"
                         "scala" "js" "jsx" "lua" "fnl" "gd"))
  (dired-rainbow-define compiled "#6cb2eb"
                        ("asm" "cl" "lisp" "el" "c" "h" "c++" "h++" "hpp"
                         "hxx" "m" "cc" "cs" "cp" "cpp" "go" "f" "for" "ftn"
                         "f90" "f95" "f03" "f08" "s" "rs" "active" "hs"
                         "pyc" "java"))
  (dired-rainbow-define executable "#8cc4ff"
                        ("com" "exe" "msi"))
  (dired-rainbow-define compressed "#51d88a"
                        ("7z" "zip" "bz2" "tgz" "txz" "gz" "xz" "z" "Z" "jar"
                         "war" "ear" "rar" "sar" "xpi" "apk" "xz" "tar" "rar"))
  (dired-rainbow-define packaged "#faad63"
                        ("deb" "rpm" "apk" "jad" "jar" "cab" "pak" "pk3" "vdf"
                         "vpk" "bsp"))
  (dired-rainbow-define encrypted "#f2d024"
                        ("gpg" "pgp" "asc" "bfe" "enc" "signature" "sig" "p12"
                         "pem"))
  (dired-rainbow-define fonts "#f6993f"
                        ("afm" "fon" "fnt" "pfb" "pfm" "ttf" "otf" "woff"
                         "woff2" "eot"))
  (dired-rainbow-define partition "#e3342f"
                        ("dmg" "iso" "bin" "nrg" "qcow" "toast" "vcd" "vmdk"
                         "bak"))
  (dired-rainbow-define vc "#6cb2eb"
                        ("git" "gitignore" "gitattributes" "gitmodules"))
  (dired-rainbow-define config "#5040e2"
                        ("cfg" "conf"))
  (dired-rainbow-define certificate "#6cb2eb"
                        ("cer" "crt" "pfx" "p7b" "csr" "req" "key"))
  (dired-rainbow-define junk "#7F7D7D"
                        ("DS_Store" "projectile"))
  (dired-rainbow-define icloud "#e3342f" ("icloud"))
  (dired-rainbow-define-chmod executable-unix "#38c172" "-.*x.*")

  (dolist (b (buffer-list))
    (with-current-buffer b
      (when (equal major-mode 'dired-mode)
        (font-lock-refresh-defaults)))))

(use-package dired-rainbow-listing
  :straight (:type git :host github :repo "mnewt/dired-rainbow-listing")
  :hook
  (dired-mode-hook . dired-rainbow-listing-mode))

(use-package dired
  :straight (:type built-in)
  :config
  (defun dired-open-file ()
    "Open file at point in OS default program."
    (interactive)
    (let* ((file (dired-get-filename nil t)))
      (message "Opening %s..." file)
      (os-open-file file)))
  :hook
  (dired-mode-hook . dired-hide-details-mode))

(use-package wdired
  :after dired
  :custom
  (wdired-allow-to-change-permissions t)
  (wdired-create-parent-directories t)
  :commands
  wdired-change-to-wdired-mode)

(use-package dired-narrow
  :after dired
  :commands
  dired-narrow)

(use-package dired-filter
  :after dired
  :custom
  (dired-filter-verbose nil)
  (dired-filter-prefix "/")
  :hook
  (dired-mode-hook . dired-filter-mode))

(use-package dired-subtree
  :after dired)

(use-package dired-collapse
  :after dired
  :hook
  (dired-mode-hook . dired-collapse-mode))

(use-package dired-list
  :after dired
  :straight (dired-list :host github :repo "Fuco1/dired-hacks"
                        :files ("dired-list.el")))

(use-package dired-quick-sort
  :after dired)

(use-package dired-git-info
  :after dired
  :bind
  (:map dired-mode-map
        ("_" . dired-git-info-mode)))


;;________ {Let's Be Evil !} ________;;
(straight-use-package 'evil)
(evil-mode 1)
;; Vim bindings for plugins: evil-collection
(straight-use-package 'evil-collection)
(evil-collection-init)
;; Comment stuff out: Evil commentary
(straight-use-package 'evil-commentary)
(evil-commentary-mode)

;;________ {Usabilidade} ________;;
(use-package helpful
  :straight t
  :commands (helpful-callable
	     helpful-variable
	     helpful-key
	     helpful-macro
	     helpful-function
	     helpful-command))

(use-package hungry-delete
  :diminish
  :hook
  (after-init . global-hungry-delete-mode))

(use-package whitespace
  :diminish
  :config
  (progn
    (setq whitespace-line-column 80) ;; limit line length
    (setq whitespace-style
          '(face trailing spaces tabs lines-tail newline
                 space-before-tab space-before-tab::tab
                 space-before-tab::space space-after-tab::tab
                 space-after-tab::space space-after-tab
                 newline-mark space-mark tab-mark))
    (setq whitespace-display-mappings
          '((space-mark 32 [183] [46])
            (newline-mark 10 [182 10])
            ;; (tab-mark 9 [?. 9] [92 9])
            (tab-mark   ?\t   [?\xBB ?\t] [?\\ ?\t]))))
  :hook
  (prog-mode . whitespace-mode)
  (text-mode . whitespace-mode)
  (protobuf-mode . whitespace-mode)
  (before-save . whitespace-cleanup))

(use-package code-cells
  :straight t
  :commands (code-cells-mode))

(use-package neotree
  :bind
  ("<f8>" . neotree-toggle)
  :config
  ;; needs package all-the-icons
  ;; (setq neo-theme (if (display-graphic-p) 'icons 'arrow))
  ;; (setq neo-theme 'arrow)
  ;; alternativa icon ou arrow
  (setq neo-theme 'icons)
  (setq neo-smart-open t)
  (setq neo-window-width 25)
  (setq-default neo-show-hidden-files t)

  (add-hook 'neo-after-create-hook
            (lambda (&rest _) (display-line-numbers-mode -1)))

  (add-hook 'neo-after-create-hook
            (lambda (&rest _) (setq mode-line-format nil)))

  (add-hook 'neo-after-create-hook
            (lambda (&rest _) (setq header-line-format nil)))
  )


(straight-use-package 'which-key)
(which-key-mode)
(setq which-key-popup-type 'minibuffer)

(use-package flycheck
  :ensure t
  :init (global-flycheck-mode))

(use-package flycheck-package
  :straight t
  :after flycheck
  :config
  (flycheck-package-setup))

(use-package ace-window)

(use-package yasnippet
  :straight t
  :hook
  (prog-mode . yas-minor-mode))

(use-package yasnippet-snippets
  :straight t)

(use-package all-the-icons
  :if (display-graphic-p))

(use-package smartparens
  :config
    (add-hook 'prog-mode-hook 'smartparens-mode)
    (setq
	   sp-base-key-bindings 'paredit
	   sp-autoskip-closing-pair 'always
	   sp-hybrid-kill-entire-symbol nil
     sp-show-pair-from-inside nil)
  (smartparens-global-mode 1))

(use-package page-break-lines
  :hook
  (emacs-lisp-mode-hook . page-break-lines-mode))

(use-package string-inflection
  :config
  (defalias #'string-inflection-snakecase #'string-inflection-underscore)
  :bind
  ("C-c C-i" . string-inflection-all-cycle))

(use-package ivy
  :diminish
  :bind (("C-s" . swiper)
         :map ivy-minibuffer-map
         ("TAB" . ivy-alt-done)
         ("C-f" . ivy-alt-done)
         ("C-l" . ivy-alt-done)
         ("C-j" . ivy-next-line)
         ("C-k" . ivy-previous-line)
         :map ivy-switch-buffer-map
         ("C-k" . ivy-previous-line)
         ("C-l" . ivy-done)
         ("C-d" . ivy-switch-buffer-kill)
         :map ivy-reverse-i-search-map
         ("C-k" . ivy-previous-line)
         ("C-d" . ivy-reverse-i-search-kill))
  :init
  (ivy-mode 1)
  :config
  (setq ivy-use-virtual-buffers t)
  (setq ivy-wrap t)
  (setq ivy-count-format "(%d/%d) ")
  (setq enable-recursive-minibuffers t)

  ;; Use different regex strategies per completion command
  (push '(completion-at-point . ivy--regex-fuzzy) ivy-re-builders-alist) ;; This doesn't seem to work...
  (push '(swiper . ivy--regex-ignore-order) ivy-re-builders-alist)
  (push '(counsel-M-x . ivy--regex-ignore-order) ivy-re-builders-alist)

  ;; Set minibuffer height for different commands
  (setf (alist-get 'counsel-projectile-ag ivy-height-alist) 15)
  (setf (alist-get 'counsel-projectile-rg ivy-height-alist) 15)
  (setf (alist-get 'swiper ivy-height-alist) 15)
  (setf (alist-get 'counsel-switch-buffer ivy-height-alist) 7))

(use-package prescient
  :after counsel
  :config
  (prescient-persist-mode 1))

(use-package ivy-prescient
  :after prescient
  :config
  (ivy-prescient-mode 1))

(use-package marginalia
  :after vertico
  :straight t
  :custom
  (marginalia-annotators '(marginalia-annotators-heavy marginalia-annotators-light nil))
  :init
  (marginalia-mode))


;;________ {Leitura} ________;;

(use-package pdf-tools
  :mode ("\\.pdf\\'" . pdf-view-mode)
  :magic ("%PDF" . pdf-view-mode)
  :config
  (pdf-loader-install)
  :bind
  (:map pdf-view-mode-map
        ("s-f" . isearch-forward)))

(use-package pdf-continuous-scroll-mode
  :after pdf-tools
  :straight (:host github :repo "dalanicolai/pdf-continuous-scroll-mode.el")
  :hook
  (pdf-view-mode-hook . pdf-continuous-scroll-mode))

;; Git
(straight-use-package 'magit)
(straight-use-package
 '(git-modes
   :type git
   :host github :repo "magit/git-modes"))

(use-package git-gutter
  :straight git-gutter-fringe
  :hook ((text-mode . git-gutter-mode)
         (prog-mode . git-gutter-mode))
  :config
	(global-git-gutter-mode 1)
  (setq git-gutter:update-interval 2))


;;======== {Linguagens aqui} ========;;
;;________ {Web} _______;;
(use-package web-mode
  :defer t
  :init
  (add-to-list 'auto-mode-alist '("\\.phtml\\'" . web-mode))
  (add-to-list 'auto-mode-alist '("\\.tpl\\.php\\'" . web-mode))
  (add-to-list 'auto-mode-alist '("\\.[agj]sp\\'" . web-mode))
  (add-to-list 'auto-mode-alist '("\\.as[cp]x\\'" . web-mode))
  (add-to-list 'auto-mode-alist '("\\.erb\\'" . web-mode))
  (add-to-list 'auto-mode-alist '("\\.mustache\\'" . web-mode))
  (add-to-list 'auto-mode-alist '("\\.djhtml\\'" . web-mode))
  (add-to-list 'auto-mode-alist '("\\.html?\\'" . web-mode))
  (add-to-list 'auto-mode-alist '("\\.ejs\\'" . web-mode))
  (add-to-list 'auto-mode-alist '("\\.tsx\\'" . web-mode))
  (add-to-list 'auto-mode-alist '("\\.jsx\\'" . web-mode))
  :config
  ;; (setq web-mode-enable-current-element-highlight t)
  ;; (setq web-mode-enable-current-column-highlight t)
  (setq-default web-mode-code-indent-offset 2)
  (setq-default web-mode-markup-indent-offset 2)
  (setq-default web-mode-attribute-indent-offset 2)
  (setq web-mode-tag-auto-close-style 1)
  (setq web-mode-auto-close-style 1))

(use-package auto-rename-tag
	:hook (web-mode . auto-rename-tag-mode))

(use-package shr-tag-pre-highlight
  :after shr
  :config
  (add-to-list 'shr-external-rendering-functions '(pre . shr-tag-pre-highlight)))

;;________ {Markdown} ________;;
(use-package markdown-mode
  :straight t
  :mode "\\.md\\'"
  :config
  (setq markdown-command
	(concat
	 "pandoc"
	 " --from=markdown --to=html"
	 " --standalone --mathjax --highlight-style=pygments"
	 " --css=pandoc.css"
	 " --quiet"
	 ))
  (setq markdown-live-preview-delete-export 'delete-on-export)
  (setq markdown-asymmetric-header t)
  (setq markdown-open-command "/home/pavel/bin/scripts/chromium-sep")
  (add-hook 'markdown-mode-hook #'smartparens-mode)
  (general-define-key
   :keymaps 'markdown-mode-map
   "M-<left>" 'markdown-promote
   "M-<right>" 'markdown-demote))

;;________ {CSS} ________;;
(setq css-indent-level 2)
(setq css-indent-offset 2)

(use-package css-mode
  :mode "\\.css\\'"
  :custom
  (css-indent-offset tab-width)
  :hook
  (css-mode-hook . lsp-deferred))

(use-package less-css-mode)

(use-package scss-mode
  :init
  (setq scss-compile-at-save nil))

;;________ {JS} ________;;
(use-package add-node-modules-path
  :hook
  ((css-mode-hook
    graphql-mode-hook
    js-mode-hook
    markdown-mode-hook
    sass-mode-hook
    web-mode-hook) . add-node-modules-path))

(setq-default js-indent-level 2)
(use-package js2-mode
  :ensure t
  :mode (("\\.js\\'" . js2-mode)
         ;; ("components?\\/.*\\.jsx?\\'" . js2-jsx-mode)
         )
  :interpreter ("node" . js2-jsx-mode)
  :init
  (add-hook 'js2-mode-hook
            (lambda ()
              (setq js2-basic-offset 2)
              ;; (add-hook 'xref-backend-functions #'xref-js2-xref-backend nil t)
              )))


;;________ {Company} ________;;
(use-package company
  :delight
  :config
  (global-company-mode)
  :custom
  ;https://github.com/company-mode/company-mode/issues/14#issuecomment-290261406
  ; Do not downcase the returned candidates automatically
  (company-dabbrev-downcase nil)
  ; Trigger completion immediately.
  (company-idle-delay 0)
  (company-minimum-prefix-length 1)
  (company-tooltip-align-annotations t)
  (company-dabbrev-other-buffers t) ; search buffers with the same major mode
  (company-selection-wrap-around t)
  ; Number the candidates (use M-1, M-2 etc to select completions).
  (company-show-numbers t)
  ;; (setq company-tooltip-limit 20)
  (setq company-show-numbers t)
  (setq company-dabbrev-downcase nil)
  (setq company-echo-delay 0.1)
  (setq company-idle-delay 0.1)
  (setq company-minimum-prefix-length 3)
  (setq company-dabbrev-downcase nil)
  (setq company-selection-wrap-around t)
  (setq company-tooltip-flip-when-above t)
  (setq company-tooltip-align-annotations t)

  (defun my-company-visible-and-explicit-action-p ()
    (and (company-tooltip-visible-p)
         (company-explicit-action-p)))
  (defun company-ac-setup ()
    "Sets up `company-mode' to behave similarly to `auto-complete-mode'."
    (setq company-require-match nil)
    (setq company-auto-complete #'my-company-visible-and-explicit-action-p)
    (setq company-frontends '(company-echo-metadata-frontend
                              company-pseudo-tooltip-unless-just-one-frontend-with-delay
                              company-preview-frontend))
    (define-key company-active-map [tab]
      'company-select-next-if-tooltip-visible-or-complete-selection)
    (define-key company-active-map (kbd "TAB")
      'company-select-next-if-tooltip-visible-or-complete-selection)))

(use-package company-tabnine
  :after company
  :config
  (add-to-list 'company-backends #'company-tabnine)
  (setq company-tabnine--disable-next-transform nil)
  (defun my-company--transform-candidates (func &rest args)
    (if (not company-tabnine--disable-next-transform)
        (apply func args)
      (setq company-tabnine--disable-next-transform nil)
      (car args)))

  (defun my-company-tabnine (func &rest args)
    (when (eq (car args) 'candidates)
      (setq company-tabnine--disable-next-transform t))
    (apply func args))

  (advice-add #'company--transform-candidates :around #'my-company--transform-candidates)
  (advice-add #'company-tabnine :around #'my-company-tabnine)
  ;; Trigger completion immediately.
  ;; (setq company-idle-delay 0)

  ;; Number the candidates (use M-1, M-2 etc to select completions).
  (setq company-show-numbers t)

  ;; Use the tab-and-go frontend.
  ;; Allows TAB to select and complete at the same time.
  (company-tng-configure-default)
  (setq company-frontends
        '(company-tng-frontend
          company-pseudo-tooltip-frontend
          company-echo-metadata-frontend)))

(use-package company-web
    :straight t)

(use-package company-quickhelp
  :after company
  :config
  (setq company-quickhelp-idle-delay 0.1)
  (company-quickhelp-mode 1))

(use-package company-statistics
  :ensure t
  :after company
  :config
  (company-statistics-mode))

 (use-package company-box
  :if window-system
  :after company
  :hook
  (company-mode-hook . company-box-mode))

(use-package company-prescient
  :after (company prescient)
  :straight t

  :preface
  (eval-when-compile
    (declare-function company-prescient-mode nil))

  :config
  (company-prescient-mode t))

;;________ {PHP} ________;;
(use-package php-mode
  :defer t
  :mode
	     ("\\.php\\'" . php-mode)
  :hook
    (php-mode-hook . lsp-deferred)
    ((php-mode . (lambda () (set (make-local-variable 'company-backends))))))
(add-to-list 'auto-mode-alist '("\\.php$" . php-mode))

(use-package phpunit
  :ensure t
  :after php-mode
  :config
  (setq phpunit-configuration-file "phpunit.xml"))

;;________ {Python} ________;;
(use-package python-mode
	:custom
	(python-shell-interpreter "python3")
  :config
  (setq auto-mode-alist
        (cons '("\\.py$" . python-mode)
         auto-mode-alist))
  (setq interpreter-mode-alist
        (cons '("python" . python-mode)
         interpreter-mode-alist))
  (autoload 'python-mode "python-mode" "Python editing mode." t))

;; pip install black
(use-package blacken
    :config
    (add-hook 'python-mode-hook 'blacken-mode))

(use-package company-jedi
  :ensure t
  :commands (company-jedi)
  :after (company python-mode))

;;________ {Vimrc} ________;;
(use-package vimrc-mode
  :mode "\\.vim\\(rc\\)?\\'")

;;________ {LSP} ________;;
(use-package lsp-mode
  :ensure
  :commands lsp
  :custom
  (lsp-enable-snippet t)
  (lsp-auto-guess-root t)
  ;; what to use when checking on-save. "check" is default, I prefer clippy
  (lsp-rust-analyzer-cargo-watch-command "clippy")
  (lsp-eldoc-render-all t)
  (lsp-idle-delay 0.6)
  (lsp-rust-analyzer-server-display-inlay-hints t)
  :config
  (add-hook 'lsp-mode-hook 'lsp-ui-mode)
    ;; Support reading large blobs of data from lsp servers.
  (setq read-process-output-max 1048576) ; 1mb
  (with-eval-after-load 'flycheck
    (add-to-list 'flycheck-checkers #'lsp)))

(use-package lsp-ui
  :ensure
  :commands lsp-ui-mode
  :custom
  (lsp-ui-peek-always-show t)
  (lsp-ui-sideline-show-hover t)
  (lsp-ui-doc-enable nil))


;; ;; Mapeamentos
(global-set-key (kbd "M-o") 'ace-window)
(global-set-key (kbd "<escape>") 'keyboard-escape-quit)
(global-set-key (kbd "<f12>") 'next-buffer)
(global-set-key (kbd "<f11>") 'previous-buffer)
















