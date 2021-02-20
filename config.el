;;; $DOOMDIR/config.el -*- lexical-binding: t; -*-

;; Place your private configuration here! Remember, you do not need to run 'doom
;; sync' after modifying this file!


;; Some functionality uses this to identify you, e.g. GPG configuration, email
;; clients, file templates and snippets.
(setq user-full-name "Paulo Eduardo Diniz"
      user-mail-address "dinizptt@gmail.com")

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
(setq doom-theme 'doom-nord)

;; If you use `org' and don't want your org files in the default location below,
;; change `org-directory'. It must be set before org loads!
(setq org-directory "~/Dropbox/org/")

;; This determines the style of line numbers in effect. If set to `nil', line
;; numbers are disabled. For relative line numbers, set this to `relative'.

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

;; Core Startup

(server-start)

(require 'org)
(require 'org-protocol)
(require 'org-capture)
(require 'org-web-tools)
(require 'helm-config)
(require 'org-id)
(require 'real-auto-save)
(require 'key-chord)

(when (memq window-system '(mac ns x))
  (exec-path-from-shell-copy-env "PYTHONPATH")
  (exec-path-from-shell-initialize))
  (add-to-list 'load-path "/usr/bin/emacsclient")
  (add-to-list 'exec-path "/usr/bin/sqlite3")
  (setq pandoc-binary "/usr/bin/pandoc")
  (setq pandoc-data-dir "~/.emacs.d/pandoc-mode/")

;; Emms

(require 'emms-setup)
(emms-all)
(emms-default-players)

(require 'emms-player-simple)
(require 'emms-source-file)
(require 'emms-source-playlist)
(setq emms-source-file-default-directory "/mnt/")

;; Modifiers

(setq mac-command-modifier 'control)
(setq mac-control-modifier 'hyper)
(setq ns-function-modifier 'hyper)
(setq w32-lwindow-modifier 'super)
(setq w32-apps-modifier 'hyper)

;; Default Font

(add-to-list 'default-frame-alist '(font . "Fira Code-13" ))
(set-face-attribute 'default t :font "Fira Code-13" )

;; iDo

(setq ido-create-new-buffer 'always)
(setq ido-file-extensions-order '(".org" ".txt" ".py" ".emacs" ".xml" ".el" ".ini" ".cfg" ".cnf"))
;; (global-set-key (kbd "C-x f") #'ido-find-file)

;; Org

(setq org-agenda-files
      (quote
      ("~/Dropbox/org/" "~/Dropbox/org/org-awesome/" "~/Dropbox/org/MediaDB/" "~/Dropbox/org/roam/" "~/Dropbox/org/textdb/")))
(setq org-archive-location "~/Dropbox/org/archive.org::* From %s")

(setq org-refile-targets
      (quote
      ((nil :maxlevel . 9)
       (org-agenda-files :tag . "heading")
       (org-agenda-files :todo . "TODO")
       (org-agenda-files :level . 1)
       (org-agenda-files :tag . "target"))))

(setq org-refile-use-outline-path (quote file))

;; Resize windows, Windmove and other tweaks

(global-set-key (kbd "M-[") 'enlarge-window)
(global-set-key (kbd "M-]") 'shrink-window)
(global-set-key (kbd "C-{") 'enlarge-window-horizontally)
(global-set-key (kbd "C-}") 'shrink-window-horizontally)

(global-set-key (kbd "H-<left>")  'windmove-left)
(global-set-key (kbd "H-<right>") 'windmove-right)
(global-set-key (kbd "H-<up>")    'windmove-up)
(global-set-key (kbd "H-<down>")  'windmove-down)
(global-set-key (kbd "C-x C-z")  'ivy-switch-buffer)

(define-key minibuffer-local-map (kbd "M-p") 'previous-complete-history-element)
(define-key minibuffer-local-map (kbd "M-n") 'next-complete-history-element)

;; Other Tweaks

(setq doom-modeline-modal-icon nil)

(defun transform-square-brackets-to-round-ones(string-to-transform)
  "Transforms [ into ( and ] into ), other chars left unchanged."
  (concat
  (mapcar #'(lambda (c) (if (equal c ?\[) ?\( (if (equal c ?\]) ?\) c))) string-to-transform))
  )

(defun switch-to-minibuffer-window ()
  "switch to minibufferx window (if active)"
  (interactive)
  (when (active-minibuffer-window)
    (select-window (active-minibuffer-window))))

;; Org Roam and Org-Journal

(use-package org-roam
    :hook
    (after-init . org-roam-mode)
    :custom
    (org-roam-directory "~/Dropbox/org/roam/")
    (org-roam-completion-system 'helm)
    (setq org-roam-buffer-window-parameters '((no-delete-other-windows . t)))
    (set-face-attribute 'org-roam-link nil
                        :foreground "deep sky blue"
                        :weight 'bold)
    (setq org-roam-capture-templates
      '(("d" "default" plain (function org-roam--capture-get-point)
         "%?"
         :file-name "${slug}"
         :head "#+title: ${title}\n\n"
         :unnarrowed t)))
    ;;(setq org-roam-dailies-directory "dailies/")
    ;;(setq org-roam-dailies-capture-templates
    ;;  '(("d" "default" entry
    ;;     #'org-roam-capture--get-point
    ;;     "* %?"
    ;;     :file-name "dailies/%<%Y-%m-%d>"
    ;;     :head "#+title: %<%Y-%m-%d>\n\n")))
    :config
    (require 'org-roam-protocol)
    (map! :leader
          :desc "OrgRoam Panel" "t o" #'org-roam-buffer-toggle-display))

;;    :bind (:map org-roam-mode-map
;;          (("C-c r o" . org-roam)
;;           ("C-c r f" . org-roam-find-file)
;;           ("C-c r g" . org-roam-graph)
;;           ("C-c n r" . org-roam-db-build-cache)
;;           :map org-mode-map
;;           (("C-c r i" . org-roam-insert))
;;           (("C-c r I" . org-roam-insert-immediate))))
 
(use-package org-journal
  :bind
  ("C-c f j" . org-journal-new-entry)
  :custom
  (org-journal-date-prefix "#+title: ")
  (org-journal-file-format "%Y-%m-%d.org")
  (org-journal-dir "~/Dropbox/org/roam/journal/")

  (org-journal-date-format "%A, %d %B %Y"))

(defun org-journal-find-location ()
  ;; Open today's journal, but specify a non-nil prefix argument in order to
  ;; inhibit inserting the heading; org-capture will insert the heading.
  (org-journal-new-entry t)
  ;; Position point on the journal's top-level heading so that org-capture
  ;; will add the new entry as a child entry.
  (goto-char (point-min)))

;; Exclude Helm Buffers from Buffer List

(defun my-buffer-predicate (buffer)
  (if (string-match "helm" (buffer-name buffer))
      nil
    t))
(set-frame-parameter nil 'buffer-predicate 'my-buffer-predicate)

;; Vim Keychord to Exit Insert Mode

(key-chord-mode 1)
;;Exit insert mode by pressing j and then j quickly
(setq key-chord-two-keys-delay 1.5)
(key-chord-define evil-insert-state-map "jj" 'evil-normal-state)

;; Hide Toolbar on new frames

(menu-bar-showhide-tool-bar-menu-customize-disable)

;; Deft

(setq deft-extensions '("org" "txt" "text" "markdown" "md"))
(setq deft-default-extension "org")
(setq deft-directory "~/Dropbox/org/textdb/")
(setq deft-recursive t)
(setq deft-text-mode 'org-mode)
(setq deft-use-filter-string-for-filename t)
(setq deft-use-filename-as-title t)
(setq deft-markdown-mode-title-level 2)

;; insert date and time

(defvar current-date-time-format "%Y-%m-%d-%H%M"
  "Format of date to insert with `insert-current-date-time' func
See help of `format-time-string' for possible replacements")

(defvar current-time-format "%a %H:%M:%S"
  "Format of date to insert with `insert-current-time' func.
Note the weekly scope of the command's precision.")

(defun insert-current-date-time ()
  "insert the current date and time into current buffer.
Uses `current-date-time-format' for the formatting the date/time."
       (interactive)
       (insert (format-time-string current-date-time-format (current-time)))
       )

(defun insert-current-time ()
  "insert the current time (1-week scope) into the current buffer."
       (interactive)
       (insert (format-time-string current-time-format (current-time)))
       )

(global-set-key (kbd "M-i") 'insert-current-date-time)
(global-set-key (kbd "M-I") 'insert-current-time)

;; Rename File and Buffer (by Steve Yegge)

;; source: http://steve.yegge.googlepages.com/my-dot-emacs-file
(defun rename-file-and-buffer (new-name)
  "Renames both current buffer and file it's visiting to NEW-NAME."
  (interactive "sNew name: ")
  (let ((name (buffer-name))
        (filename (buffer-file-name)))
    (if (not filename)
        (message "Buffer '%s' is not visiting a file!" name)
      (if (get-buffer new-name)
          (message "A buffer named '%s' already exists!" new-name)
        (progn
          (rename-file filename new-name 1)
          (rename-buffer new-name)
          (set-visited-file-name new-name)
          (set-buffer-modified-p nil))))))

;; New File Capture Template Function

(defun psachin/create-notes-file ()
  "Create an org file in ~/Dropbox/TextDB/."
  (interactive)
  (let ((name (read-string "Filename: ")))
    (expand-file-name (format "%s.org"
                                name) "~/Dropbox/TextDB/")))

;; Org Capture Templates

(setq org-capture-templates '(
      ("t" "Todo" entry (file "~/Dropbox/org/refile.org")
       "* TODO %?\n%U\n%a\n" :clock-in t :clock-resume t)
      ("tl" "Ligacão" entry (file "~/Dropbox/org/refile.org")
       "* PHONE %? :ligacão:\n%U" :clock-in t :clock-resume t)
      ("e" "Responder Email" entry (file "~/Dropbox/org/refile.org")
       "* TODO  Respond to %:from on %:subject\nSCHEDULED: %t\n%U\n%a\n" :clock-in t :clock-resume t :immediate-finish t)
      ("n" "Note" entry (file "~/Dropbox/org/refile.org")
       "* %? :note:\n%U\n%a\n" :clock-in t :clock-resume t)
      ("r" "Reunião" entry (file "~/Dropbox/org/refile.org")
       "* Reunião com %? :reunião:\n%U" :clock-in t :clock-resume t)
      ("s" "Selection (on emacs)" entry (file "~/Dropbox/org/refile.org")
       "* %i%? - %U")
      ("c" "Clipboard" entry (file "~/Dropbox/org/refile.org")
       "* %c%? - %U")
      ("o" "Org Store Link (on emacs)" entry (file "~/Dropbox/org/refile.org")
       "* %a%? - %U")
      ("m" "Music" entry (file+headline "~/Dropbox/org/refile.org" "Music on Radar")
       "* %?Music")
      ("mo" "Movies" entry (file+headline "~/Dropbox/org/refile.org" "Movies to Watch")
       "* %?Movie")
      ("b" "Books" entry (file+headline "~/Dropbox/org/refile.org" "Books to Read")
       "* %?Book")
      ("g" "Games" entry (file+headline "~/Dropbox/org/refile.org" "Games to Play")
       "* %?Game")
      ("s" "TV Series" entry (file+headline "~/Dropbox/org/refile.org" "TV Series to Watch")
       "* %?Series")
      ("!" "New File @ TextDB" entry (file psachin/create-notes-file)
       "* TITLE%?\n %U")
      ("p" "Protocol" entry (file "~/Dropbox/org/inbox.org")
       "* %^{Title}\nSource: %U, %a\n #+BEGIN_QUOTE\n%i\n#+END_QUOTE\n\n")
      ("L" "Protocol Link" entry (file "~/Dropbox/org/inbox.org")
       "* %(transform-square-brackets-to-round-ones \"%:description\")\nSource: %:link - captured on: %U")
      ))

;; Default Font

(add-to-list 'default-frame-alist '(font . "Fira Code-13" ))
(set-face-attribute 'default t :font "Fira Code-13" )

;; Org-Refile Tweaks (by Aaron Bieber)

(setq org-refile-use-outline-path 'file) ;; Allow refile to top level
(setq org-outline-path-complete-in-steps nil) ;; Make above work properly in Helm
(setq org-refile-allow-creating-parent-nodes 'confirm) ;; Allow creating parent node on-the-fly

;; Systemwide Org-Capture with separate frame
;;
;; to call org capture from anywhere in my system via emacsclient -c -F '(quote (name . "capture"))' -e '(activate-capture-frame)'
;; to setup extension check https://github.com/sprig/org-capture-extension

(defadvice org-switch-to-buffer-other-window
  (after supress-window-splitting activate)
  "Delete the extra window if we're in a capture frame"
  (if (equal "capture" (frame-parameter nil 'name))
      (delete-other-windows)))

(defadvice org-capture-finalize
(after delete-capture-frame activate)
  "Advise capture-finalize to close the frame"
  (when (and (equal "capture" (frame-parameter nil 'name))
	     (not (eq this-command 'org-capture-refile)))
(delete-frame)))

(defadvice org-capture-refile
(after delete-capture-frame activate)
  "Advise org-refile to close the frame"
  (delete-frame))

(defun activate-capture-frame ()
  "run org-capture in capture frame"
  (select-frame-by-name "capture")
  (switch-to-buffer (get-buffer-create "*scratch*"))
  (org-capture))

;; Projectile Projects

(projectile-add-known-project "~/Dropbox/org")
(projectile-add-known-project "~/Dropbox/org/MediaDB")
(projectile-add-known-project "~/Dropbox/OrgWork")
(projectile-add-known-project "~/Dropbox/org/roam")

;; Global Auto Revert Mode

(global-auto-revert-mode 1)

;; Real Auto-Save - Only on Org-mode files

(setq real-auto-save-use-idle-timer t)
(setq real-auto-save-interval 10)
(add-hook 'org-mode-hook 'real-auto-save-mode)

;; Org-Pandoc-Import

(use-package! org-pandoc-import :after org)

;; Sets org-mode for .txt files

(add-to-list 'auto-mode-alist '("TextDB/.*[.]txt$" . org-mode))

;; Markdown Mode ;;

(use-package markdown-mode
  :commands (markdown-mode gfm-mode)
  :mode (("README\\.md\\'" . gfm-mode)
         ("\\.md\\'" . markdown-mode)
         ("\\.markdown\\'" . markdown-mode))
  :init (setq markdown-command "pandoc"))

;; insert date and time

(defvar current-date-time-format "%Y-%m-%d-%H%M"
  "Format of date to insert with `insert-current-date-time' func
See help of `format-time-string' for possible replacements")

(defvar current-time-format "%a %H:%M:%S"
  "Format of date to insert with `insert-current-time' func.
Note the weekly scope of the command's precision.")

(defun insert-current-date-time ()
  "insert the current date and time into current buffer.
Uses `current-date-time-format' for the formatting the date/time."
       (interactive)
       (insert (format-time-string current-date-time-format (current-time)))
       )

(defun insert-current-time ()
  "insert the current time (1-week scope) into the current buffer."
       (interactive)
       (insert (format-time-string current-time-format (current-time)))
       )

(global-set-key (kbd "M-i") 'insert-current-date-time)
(global-set-key (kbd "M-I") 'insert-current-time)

;; Berndt Hansen's Functions with Shortcuts

(global-set-key (kbd "<f5>") 'bh/org-todo)

(defun bh/org-todo (arg)
  (interactive "p")
  (if (equal arg 4)
      (save-restriction
        (bh/narrow-to-org-subtree)
        (org-show-todo-tree nil))
    (bh/narrow-to-org-subtree)
    (org-show-todo-tree nil)))

(global-set-key (kbd "<S-f5>") 'bh/widen)

(defun bh/widen ()
  (interactive)
  (if (equal major-mode 'org-agenda-mode)
      (progn
        (org-agenda-remove-restriction-lock)
        (when org-agenda-sticky
          (org-agenda-redo)))
    (widen)))

(add-hook 'org-agenda-mode-hook
          '(lambda () (org-defkey org-agenda-mode-map "W" (lambda () (interactive) (setq bh/hide-scheduled-and-waiting-next-tasks t) (bh/widen))))
          'append)

;;(global-set-key (kbd "<f9> b") 'bbdb)
;;(global-set-key (kbd "<f9> c") 'calendar)
(global-set-key (kbd "<f9> f") 'boxquote-insert-file)
;;(global-set-key (kbd "<f9> g") 'gnus)
(global-set-key (kbd "<f9> h") 'bh/hide-other)
(global-set-key (kbd "<f9> n") 'bh/toggle-next-task-display)
(global-set-key (kbd "<f9> I") 'bh/punch-in)
(global-set-key (kbd "<f9> O") 'bh/punch-out)
(global-set-key (kbd "<f9> o") 'bh/make-org-scratch)
(global-set-key (kbd "<f9> r") 'boxquote-region)
(global-set-key (kbd "<f9> s") 'bh/switch-to-scratch)
(global-set-key (kbd "<f9> t") 'bh/insert-inactive-timestamp)
(global-set-key (kbd "<f9> T") 'bh/toggle-insert-inactive-timestamp)
(global-set-key (kbd "<f9> v") 'visible-mode)
(global-set-key (kbd "<f9> l") 'org-toggle-link-display)
(global-set-key (kbd "<f9> SPC") 'bh/clock-in-last-task)
(global-set-key (kbd "<f11>") 'org-clock-goto)
(global-set-key (kbd "C-<f11>") 'org-clock-in)
(global-set-key (kbd "C-x n r") 'narrow-to-region)
(global-set-key (kbd "M-<f5>") 'org-toggle-inline-images)

(defun bh/hide-other ()
  (interactive)
  (save-excursion
    (org-back-to-heading 'invisible-ok)
    (hide-other)
    (org-cycle)
    (org-cycle)
    (org-cycle)))

(defun bh/make-org-scratch ()
  (interactive)
  (find-file "/tmp/publish/scratch.org")
  (gnus-make-directory "/tmp/publish"))

(defun bh/switch-to-scratch ()
  (interactive)
  (switch-to-buffer "*scratch*"))

(defvar bh/insert-inactive-timestamp t)

(defun bh/toggle-insert-inactive-timestamp ()
  (interactive)
  (setq bh/insert-inactive-timestamp (not bh/insert-inactive-timestamp))
  (message "Heading timestamps are %s" (if bh/insert-inactive-timestamp "ON" "OFF")))

(defun bh/insert-inactive-timestamp ()
  (interactive)
  (org-insert-time-stamp nil t t nil nil nil))

;; (defun bh/insert-heading-inactive-timestamp ()
;;  (save-excursion
;;    (when bh/insert-inactive-timestamp
;;      (org-return)
;;      (org-cycle)
;;      (bh/insert-inactive-timestamp))))

;; (add-hook 'org-insert-heading-hook 'bh/insert-heading-inactive-timestamp 'append)

(defun bh/clock-in-to-next (kw)
  "Switch a task from TODO to NEXT when clocking in.
Skips capture tasks, projects, and subprojects.
Switch projects and subprojects from NEXT back to TODO"
  (when (not (and (boundp 'org-capture-mode) org-capture-mode))
    (cond
     ((and (member (org-get-todo-state) (list "TODO"))
           (bh/is-task-p))
      "NEXT")
     ((and (member (org-get-todo-state) (list "NEXT"))
           (bh/is-project-p))
      "TODO"))))

(defun bh/find-project-task ()
  "Move point to the parent (project) task if any"
  (save-restriction
    (widen)
    (let ((parent-task (save-excursion (org-back-to-heading 'invisible-ok) (point))))
      (while (org-up-heading-safe)
        (when (member (nth 2 (org-heading-components)) org-todo-keywords-1)
          (setq parent-task (point))))
      (goto-char parent-task)
      parent-task)))

(defun bh/punch-in (arg)
  "Start continuous clocking and set the default task to the
selected task.  If no task is selected set the Organization task
as the default task."
  (interactive "p")
  (setq bh/keep-clock-running t)
  (if (equal major-mode 'org-agenda-mode)
      ;;
      ;; We're in the agenda
      ;;
      (let* ((marker (org-get-at-bol 'org-hd-marker))
             (tags (org-with-point-at marker (org-get-tags-at))))
        (if (and (eq arg 4) tags)
            (org-agenda-clock-in '(16))
          (bh/clock-in-organization-task-as-default)))
    ;;
    ;; We are not in the agenda
    ;;
    (save-restriction
      (widen)
      ; Find the tags on the current task
      (if (and (equal major-mode 'org-mode) (not (org-before-first-heading-p)) (eq arg 4))
          (org-clock-in '(16))
        (bh/clock-in-organization-task-as-default)))))

(defun bh/punch-out ()
  (interactive)
  (setq bh/keep-clock-running nil)
  (when (org-clock-is-active)
    (org-clock-out))
  (org-agenda-remove-restriction-lock))

(defun bh/clock-in-default-task ()
  (save-excursion
    (org-with-point-at org-clock-default-task
      (org-clock-in))))

(defun bh/clock-in-parent-task ()
  "Move point to the parent (project) task if any and clock in"
  (let ((parent-task))
    (save-excursion
      (save-restriction
        (widen)
        (while (and (not parent-task) (org-up-heading-safe))
          (when (member (nth 2 (org-heading-components)) org-todo-keywords-1)
            (setq parent-task (point))))
        (if parent-task
            (org-with-point-at parent-task
              (org-clock-in))
          (when bh/keep-clock-running
            (bh/clock-in-default-task)))))))

(defvar bh/organization-task-id "5215ec32-9154-4cc6-8e60-dd4bd440970c")

(defun bh/clock-in-organization-task-as-default ()
  (interactive)
  (org-with-point-at (org-id-find bh/organization-task-id 'marker)
    (org-clock-in '(16))))

(defun bh/clock-out-maybe ()
  (when (and bh/keep-clock-running
             (not org-clock-clocking-in)
             (marker-buffer org-clock-default-task)
             (not org-clock-resolving-clocks-due-to-idleness))
    (bh/clock-in-parent-task)))

(add-hook 'org-clock-out-hook 'bh/clock-out-maybe 'append)

(defun bh/clock-in-task-by-id (id)
  "Clock in a task by id"
  (org-with-point-at (org-id-find id 'marker)
    (org-clock-in nil)))

(defun bh/clock-in-last-task (arg)
  "Clock in the interrupted task if there is one
Skip the default task and get the next one.
A prefix arg forces clock in of the default task."
  (interactive "p")
  (let ((clock-in-to-task
         (cond
          ((eq arg 4) org-clock-default-task)
          ((and (org-clock-is-active)
                (equal org-clock-default-task (cadr org-clock-history)))
           (caddr org-clock-history))
          ((org-clock-is-active) (cadr org-clock-history))
          ((equal org-clock-default-task (car org-clock-history)) (cadr org-clock-history))
          (t (car org-clock-history)))))
    (widen)
    (org-with-point-at clock-in-to-task
      (org-clock-in nil))))

(setq org-time-stamp-rounding-minutes (quote (1 1)))

(setq org-agenda-clock-consistency-checks
      (quote (:max-duration "4:00"
              :min-duration 0
              :max-gap 0
              :gap-ok-around ("4:00"))))

(defun bh/toggle-next-task-display ()
  (interactive)
  (setq bh/hide-scheduled-and-waiting-next-tasks (not bh/hide-scheduled-and-waiting-next-tasks))
  (when  (equal major-mode 'org-agenda-mode)
    (org-agenda-redo))
  (message "%s WAITING and SCHEDULED NEXT Tasks" (if bh/hide-scheduled-and-waiting-next-tasks "Hide" "Show")))

;; Resume clocking task when emacs is restarted
(org-clock-persistence-insinuate)
;;
;; Show lot of clocking history so it's easy to pick items off the C-F11 list
(setq org-clock-history-length 23)
;; Resume clocking task on clock-in if the clock is open
(setq org-clock-in-resume t)
;; Change tasks to NEXT when clocking in
(setq org-clock-in-switch-to-state 'bh/clock-in-to-next)
;; Separate drawers for clocking and logs
(setq org-drawers (quote ("PROPERTIES" "LOGBOOK")))
;; Save clock data and state changes and notes in the LOGBOOK drawer
(setq org-clock-into-drawer t)
;; Sometimes I change tasks I'm clocking quickly - this removes clocked tasks with 0:00 duration
(setq org-clock-out-remove-zero-time-clocks t)
;; Clock out when moving task to a done state
(setq org-clock-out-when-done t)
;; Save the running clock and all clock history when exiting Emacs, load it on startup
(setq org-clock-persist t)
;; Do not prompt to resume an active clock
(setq org-clock-persist-query-resume nil)
;; Enable auto clock resolution for finding open clocks
(setq org-clock-auto-clock-resolution (quote when-no-clock-is-running))
;; Include current clocking task in clock reports
(setq org-clock-report-include-clocking-task t)
(setq bh/keep-clock-running nil)
(setq org-export-with-timestamps nil)
(setq org-return-follows-link t)

;; Org-clock Settings

(setq org-clock-persist 'history)
(org-clock-persistence-insinuate)
