#lang racket/gui

(provide welcome-message)

(define welcome-text
  "Spitter is the most minimalistic writing program.
Press Ctrl-S to spit the text to the file \"output\" in the working directory.")

(define welcome-message
  (new frame% [label "Spitter: a Minimal Writer"]
       [border 10]
       [spacing 10]))

(new message%
     [label welcome-text]
     [parent welcome-message])

(new button% [label "Close"]
     [parent welcome-message]
     [callback (lambda (b e)
                 (send welcome-message show #f))])
