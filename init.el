;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; Setup a quick command to open this file 
(defun initfile ()
  (interactive)
  (find-file "~/.emacs.d/init.el"))

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; Configuration File globals
(defvar emacs-config-path "~/.emacs.d/"
  "The path to the emacs configuration directory")

;; Add melpa to the package-archives list
;(add-to-list 'package-archives '("melpa" . "http://melpa.milkbox.net/packages/") t)
(setq package-archives '(("gnu" . "http://elpa.gnu.org/packages/")
			 ("marmalade" . "http://marmalade-repo.org/packages/")
			 ("melpa" . "http://melpa.milkbox.net/packages/")))

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; Customize iDo
(ido-mode t)

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; Customize Emacs Themes

(add-to-list 'custom-theme-load-path "~/.emacs.d/themes/")
(add-to-list 'custom-theme-load-path "~/.emacs.d/themes/solarized")
(load-theme 'solarized-dark t)

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; Customize Helm
(add-to-list 'load-path (expand-file-name "helm-20121218.1832" emacs-config-path))
(require 'helm-config)

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; Customize YaSnippets
(defvar yasnippet-path (expand-file-name "yasnippet-0.8.0" emacs-config-path))
(add-to-list 'load-path yasnippet-path)
(require 'yasnippet)

(yas--initialize)
(yas/load-directory (expand-file-name "snippets" yasnippet-path))


;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; Customize Expand Region
(add-to-list 'load-path (expand-file-name "helm-20121218.1832" ))
(require 'helm-config)
	     
	     
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; Customize org-mode
(defvar org-mode-docs-path "~/org" "Path to the org-mode user documents")

(setq org-agenda-files (quote ("~/org/gtd.org"
			       "~/org/diary.org"
			       "~/org/travel.org")))

(setq org-todo-keywords
      (quote ((sequence "TODO(t)" "NEXT(n)" "|" "DONE(d)")
              (sequence "WAITING(w@/!)" "HOLD(h@/!)" "|" "CANCELLED(c@/!)" "PHONE")
	      (sequence "FLIGHT(f)")
	      (sequence "HOTEL(h)")
	      (sequence "CAR RESERVATION(c)"))))
      
(setq org-global-properties 
      (quote (("effort_ALL" . "0:10 0:30 1:00 2:00 3:00 4:00 5:00 6:00 8:00"))))

(setq org-todo-keyword-faces
      (quote (("TODO" :foreground "red" :weight bold)
              ("NEXT" :foreground "blue" :weight bold)
              ("DONE" :foreground "forest green" :weight bold)
              ("WAITING" :foreground "orange" :weight bold)
              ("HOLD" :foreground "magenta" :weight bold)
              ("CANCELLED" :foreground "forest green" :weight bold)
              ("PHONE" :foreground "forest green" :weight bold)
	      ("FLIGHT" :foreground "orange" :weight bold)
	      ("HOTEL" :foreground "magenta" :weight bold)
	      ("CAR RESERVATION" :foreground "blue" :weight bold))))

(setq org-capture-templates
      (quote (("t" "todo" entry (file "~/org/gtd.org") "* %^{Effort}pTODO %?%t\n\n")
              ("d" "diary" entry (file+datetree "~/org/diary.org") "* %?\n%U\n" :prepend)
	      ("f" "flight" entry (file "~/org/travel.org")
               "* FLIGHT %^{to}p%^{from}p%^{airline}p%^{flightnumber}p%^{Reason for the flight|A conference|An Application Lab}\nwhen: %t\n\n" :prepend)
              ("h" "hotel" entry (file "~/org/travel.org")
               "* HOTEL %^{hotel}p%^{address}p%?\nwhen: %t\n\n" :prepend)
              ("c" "CAR RESERVATION" entry (file "~/org/travel.org")
               "* HOTEL %^{pickup}p%^{return}p%?\nwhen: %t\n\n" :prepend)
)))

;; Capture templates for: TODO tasks, Notes, appointments, phone calls, and org-protocol
(setq org-use-fast-todo-selection t)




;;;; Customize the org-mode agenda view
;; Custom agenda command definitions
(defun my-skip-unless-waiting ()
  "Skip trees that are not waiting"
  (let ((subtree-end (save-excursion (org-end-of-subtree t))))
    (if (re-search-forward "WAITING" subtree-end t)
	nil          ; tag found, do not skip
      subtree-end))) ; tag not found, continue after end of subtree

(org-add-agenda-custom-command
 '("b" todo "Waiting"
   ((org-agenda-skip-function 'my-skip-unless-waiting)
    (org-agenda-overriding-header "Projects waiting for something: "))))


(setq org-agenda-custom-commands
      '(("c" "Calendar" agenda ""
         ((org-agenda-ndays 31)                          ;; [1]
          (org-agenda-start-on-weekday 0)               ;; [2]
          (org-agenda-time-grid nil)                    
          (org-agenda-repeating-timestamp-show-all t)   ;; [3]
          (org-agenda-entry-types '(:timestamp :sexp))))  ;; [4]
      ;; other commands go here
        ))

(setq org-agenda-custom-commands
      '(("d" "Upcoming deadlines" agenda "" 
                ((org-agenda-time-grid nil)
                 (org-deadline-warning-days 365)        ;; [1]
                 (org-agenda-entry-types '(:scheduled))  ;; [2]
                 ))
      ;; other commands go here
       ))




;;;; Refiling configurations
; Targets include this file and any file contributing to the agenda - up to 9 levels deep
(setq org-refile-targets (quote ((nil :maxlevel . 9)
                                 (org-agenda-files :maxlevel . 9))))

; Use full outline paths for refile targets - we file directly with IDO
(setq org-refile-use-outline-path t)

; Targets complete directly with IDO
(setq org-outline-path-complete-in-steps nil)

; Allow refile to create parent tasks with confirmation
(setq org-refile-allow-creating-parent-nodes (quote confirm))

; Use IDO for both buffer and file completion and ido-everywhere to t
(setq org-completion-use-ido t)
(setq ido-everywhere t)
(setq ido-max-directory-size 100000)
(ido-mode (quote both))

;;;; Refile settings
; Exclude DONE state tasks from refile targets
(defun dh/verify-refile-target ()
  "Exclude todo keywords with a done state from refile targets"
  (not (member (nth 2 (org-heading-components)) org-done-keywords)))

(setq org-refile-target-verify-function 'dh/verify-refile-target)



; Use IDO for both buffer and file completion and ido-everywhere to t
(setq org-completion-use-ido t)
(setq ido-everywhere t)
(setq ido-max-directory-size 100000)
(ido-mode (quote both))

;;;; Clock configurations
;; Resume clocking task when emacs is restarted
;; (org-clock-persistence-insinuate)

;; ;; Show lot sof clocking history so it's easy to pick items off the C-F11 list
;; (setq org-clock-history-length 36)
;; ;; Resume clocking task on clock-in if the clock is open
;; (setq org-clock-in-resume t)
;; ;; Change tasks to NEXT when clocking in
;; (setq org-clock-in-switch-to-state 'bh/clock-in-to-next)
;; ;; Separate drawers for clocking and logs
;; (setq org-drawers (quote ("PROPERTIES" "LOGBOOK")))
;; ;; Save clock data and state changes and notes in the LOGBOOK drawer
;; (setq org-clock-into-drawer t)
;; ;; Sometimes I change tasks I'm clocking quickly - this removes clocked tasks with 0:00 duration
;; (setq org-clock-out-remove-zero-time-clocks t)
;; ;; Clock out when moving task to a done state
;; (setq org-clock-out-when-done t)
;; ;; Save the running clock and all clock history when exiting Emacs, load it on startup
;; (setq org-clock-persist t)
;; ;; Do not prompt to resume an active clock
;; (setq org-clock-persist-query-resume nil)
;; ;; Enable auto clock resolution for finding open clocks
;; (setq org-clock-auto-clock-resolution (quote when-no-clock-is-running))
;; ;; Include current clocking task in clock reports
;; (setq org-clock-report-include-clocking-task t)


;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; Keybindings
(global-set-key (kbd "C-c h") 'helm-mini)
;(global-set-key (kbd "C-x C-f") 'helm-find-files)

(global-set-key (kbd "C-M-r") 'org-capture)
(global-set-key (kbd "C-c a") 'org-agenda)





