#lang racket/gui

(require "main-window.rkt")

(provide start-spitter)

(define (start-spitter)
  (send main-window show #t))
