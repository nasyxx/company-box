;;; company-box-icons.el --- Company front-end  -*- lexical-binding: t -*-

;; Copyright (C) 2017 Sebastien Chapuis

;; Author: Sebastien Chapuis <sebastien@chapu.is>
;; URL: https://github.com/sebastiencs/company-box

;;; License
;;
;; This program is free software; you can redistribute it and/or modify
;; it under the terms of the GNU General Public License as published by
;; the Free Software Foundation; either version 3, or (at your option)
;; any later version.

;; This program is distributed in the hope that it will be useful,
;; but WITHOUT ANY WARRANTY; without even the implied warranty of
;; MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
;; GNU General Public License for more details.

;; You should have received a copy of the GNU General Public License
;; along with this program; see the file COPYING.  If not, write to
;; the Free Software Foundation, Inc., 51 Franklin Street, Fifth
;; Floor, Boston, MA 02110-1301, USA.

;;; Commentary:
;;
;; Icons for company-box

;;; Code:

(require 'dash)

(defvar company-box-icons-unknown
  'fa_question_circle
  "Icon used when on unknown item.
See `company-box-icons-functions'.")

(defvar company-box-icons-elisp
  '((fa_tag :face font-lock-function-name-face)
    (fa_cog :face font-lock-variable-name-face)
    (fa_cube :face font-lock-constant-face)
    (md_color_lens :face font-lock-doc-face))
  "List of icons to use with Emacs Lisp candidates.
It has the form:
(FUNCTION VALUE FEATURE FACE).
See `company-box-icons-functions'.")

(defvar company-box-icons-yasnippet
  'fa_bookmark
  "Icon to use with yasnippet candidates.
See `company-box-icons-functions'.")

(defvar company-box-icons-lsp
  '((1 . fa_text_height) ;; Text
    (2 . (fa_tags :face font-lock-function-name-face)) ;; Method
    (3 . (fa_tag :face font-lock-function-name-face)) ;; Function
    (4 . (fa_tag :face font-lock-function-name-face)) ;; Constructor
    (5 . (fa_cog :face font-lock-variable-name-face)) ;; Field
    (6 . (fa_cog :face font-lock-variable-name-face)) ;; Variable
    (7 . (fa_cube :face font-lock-type-face)) ;; Class
    (8 . (fa_cube :face font-lock-type-face)) ;; Interface
    (9 . (fa_cube :face font-lock-type-face)) ;; Module
    (10 . (fa_cog :face font-lock-variable-name-face)) ;; Property
    (11 . md_settings_system_daydream) ;; Unit
    (12 . (fa_cog :face font-lock-variable-name-face)) ;; Value
    (13 . (md_storage :face font-lock-type-face)) ;; Enum
    (14 . (md_closed_caption :face font-lock-keyword-face)) ;; Keyword
    (15 . md_closed_caption) ;; Snippet
    (16 . (md_color_lens :face font-lock-doc-face)) ;; Color
    (17 . fa_file_text_o) ;; File
    (18 . md_refresh) ;; Reference
    (19 . fa_folder_open) ;; Folder
    (20 . (md_closed_caption :face font-lock-type-face)) ;; EnumMember
    (21 . (fa_square :face font-lock-constant-face)) ;; Constant
    (22 . (fa_cube :face font-lock-type-face)) ;; Struct
    (23 . fa_calendar) ;; Event
    (24 . fa_square_o) ;; Operator
    (25 . fa_arrows)) ;; TypeParameter
  "List of Icons to use with LSP candidates.

Elements are of the form:
(KIND . ICON)

Where KIND correspond to a number, the CompletionItemKind from the LSP [1]

ICON can be a symbol, a list or a string.
- SYMBOL:  It is the name of the icon.
- LIST:    The list is then `apply' to `icons-in-terminal' function.
           Example: '(fa_icon :face some-face :foreground \"red\")
- STRING:  A simple string which is inserted, should be of length 1


[1] https://github.com/Microsoft/language-server-protocol/blob/gh-pages/specification.md#completion-request-leftwards_arrow_with_hook

See `company-box-icons-functions'.")

(defun company-box-icons~lsp (candidate)
  (-when-let* ((lsp-item (get-text-property 0 'lsp-completion-item candidate))
               (kind (gethash "kind" lsp-item)))
    (alist-get kind company-box-icons-lsp)))

(defun company-box-icons~elisp (candidate)
  (when (derived-mode-p 'emacs-lisp-mode)
    (let* ((sym (intern candidate))
           (item (cond ((fboundp sym) 0)
                       ((boundp sym) 1)
                       ((featurep sym) 2)
                       ((facep sym) 3))))
      (when item
        (nth item company-box-icons-elisp)))))

(defun company-box-icons~yasnippet (candidate)
  (when (get-text-property 0 'yas-annotation candidate)
    company-box-icons-yasnippet))

(provide 'company-box-icons)
;;; company-box-icons.el ends here