;; depends on
;;  Load 7 ASDF systems:
;;    alexandria asdf bordeaux-threads cl-base64
;;    trivial-features trivial-gray-streams uiop
;;  Install 7 Quicklisp releases:
;;    cffi cl+ssl cl-smtp flexi-streams split-sequence
;;    trivial-garbage usocket

(ql:update-dist "quicklisp")
(ql:update-client)
(ql:quickload "cl-smtp")


(require 'cl-smtp)

;; saved in /Users/james/common-lisp/timer-0.4.0
(require 'timer)

