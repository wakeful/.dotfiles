;;; $DOOMDIR/config.el -*- lexical-binding: t; -*-

;; Place your private configuration here! Remember, you do not need to run 'doom
;; sync' after modifying this file!

;; Some functionality uses this to identify you, e.g. GPG configuration, email
;; clients, file templates and snippets.
(setq user-full-name "AJ"
      user-mail-address "aj@48k.io")

;; Doom exposes five (optional) variables for controlling fonts in Doom. Here
;; are the three important ones:
;;
;; + `doom-font'
;; + `doom-variable-pitch-font'
;; + `doom-big-font' -- used for `doom-big-font-mode'; use this for
;;   presentations or streaming.
;;
;; They all accept either a font-spec, font string ("Input Mono-12"), or xlfd
;; font string. You generally only need these two:
;; (setq doom-font (font-spec :family "monospace" :size 12 :weight 'semi-light)
;;       doom-variable-pitch-font (font-spec :family "sans" :size 13))

;; There are two ways to load a theme. Both assume the theme is installed and
;; available. You can either set `doom-theme' or manually load a theme with the
;; `load-theme' function. This is the default:
;;(setq doom-theme 'doom-one)
;;(setq doom-theme 'doom-gruvbox)
(setq doom-theme 'doom-nord)

;; If you use `org' and don't want your org files in the default location below,
;; change `org-directory'. It must be set before org loads!
(setq org-directory "~/org/")

;; This determines the style of line numbers in effect. If set to `nil', line
;; numbers are disabled. For relative line numbers, set this to `relative'.
(setq display-line-numbers-type t)

(setq projectile-project-search-path '("~/laatu/proj"))

(setq docker-command "/usr/local/bin/docker")
(setq docker-compose-command "/usr/local/bin/docker-compose")

(use-package undo-tree
  :ensure t
  :init
  (global-undo-tree-mode))

(add-hook!
 'evil-local-mode-hook 'turn-on-undo-tree-mode)

(after! org
  (map! :map org-mode-map
        :n "M-j" #'org-metadown
        :n "M-k" #'org-metaup))
;; Here are some additional functions/macros that could help you configure Doom:
;;
;; - `load!' for loading external *.el files relative to this one
;; - `use-package!' for configuring packages
;; - `after!' for running code after a package has loaded
;; - `add-load-path!' for adding directories to the `load-path', relative to
;;   this file. Emacs searches the `load-path' when you load packages with
;;   `require' or `use-package'.
;; - `map!' for binding new keys
;;
;; To get information about any of these functions/macros, move the cursor over
;; the highlighted symbol at press 'K' (non-evil users must press 'C-c c k').
;; This will open documentation for it, including demos of how they are used.
;;
;; You can also try 'gd' (or 'C-c c d') to jump to their definition and see how
;; they are implemented.

(setq elfeed-feeds
      '("https://asahilinux.org/blog/index.xml"
        "https://blog.golang.org/feed.atom"))
(after! elfeed
  (setq elfeed-db-directory "~/.elfeed")
  (setq elfeed-search-filter "+unread @2-weeks-ago"))
  ;;(setq elfeed-search-filter "@2-weeks-ago +unread"))
(add-hook! 'elfeed-search-mode-hook 'elfeed-update)

(use-package! vterm
  :config
  (setq vterm-kill-buffer-on-exit 'nil))

(custom-set-faces!
  '(aw-leading-char-face
    :foreground "#797E21" :background "#1E1E1E"
    :weight bold :height 2.4 :box (:line-width 2 :color "#6E1C1B")))

(define-key vterm-mode-map (kbd "C-c C-c") 'vterm-send-C-c)

(add-hook 'magit-mode-hook (lambda () (
                                       magit-delta-mode +1)))

(setq plantuml-jar-path "~/bin/plantuml.jar")
(add-hook 'plantuml-mode (lambda ()(
                                    plantuml-default-exec-mode 'jar)))

(add-hook 'ibuffer-mode-hook (lambda ()(
                                        ibuffer-auto-mode t)))

(global-set-key
 (kbd "<f2>")
 (defhydra hydra-zoom (:color amaranth)
  "zoom"
  ("k" text-scale-increase "+")
  ("j" text-scale-decrease "-")
  ("r" (text-scale-set 0)  "reset")
  ("SPC" nil               "cancel")
 ))

(global-set-key
 (kbd "<f3>")
 (defhydra hydra-window ()
  "
^Movement^      ^Split^         ^Switch^        ^Resize^
----------------------------------------------------------------
_h_ ←           _v_ertical      _b_uffer        _q_ X←
_j_ ↓           _x_ horizontal  _f_ind files    _w_ X↓
_k_ ↑           _z_ undo        _s_wap          _e_ X↑
_l_ →                                       _r_ X→
_SPC_ cancel    _o_nly this     _d_elete
"
  ("h" windmove-left )
  ("j" windmove-down )
  ("k" windmove-up )
  ("l" windmove-right )
  ("q" hydra-move-splitter-left)
  ("w" hydra-move-splitter-down)
  ("e" hydra-move-splitter-up)
  ("r" hydra-move-splitter-right)
  ("b" +ivy/switch-workspace-buffer)
  ("f" find-file)
  ("v" (lambda ()
          (interactive)
          (split-window-right)
          (windmove-right))
       )
  ("x" (lambda ()
          (interactive)
          (split-window-below)
          (windmove-down))
       )
  ("s" (lambda ()
          (interactive)
          (ace-window 4)
          (add-hook 'ace-window-end-once-hook
                    'hydra-window/body)))
  ("d" delete-window)
  ("o" delete-other-windows)
  ("z" (progn
          (winner-undo)
          (setq this-command 'winner-undo))
  )
  ("SPC" nil)
  ))
