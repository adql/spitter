#lang racket/gui

(require "main-window.rkt")
(require "welcome.rkt")

(provide start-spitter)

(define (start-spitter)
  (send main-window show #t)
  (send welcome-message show #t))
