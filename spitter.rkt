#lang racket/gui

(define frame
  (new (class frame%
         (super-new)
         (define/public (on-dump-keys event)
           ;; Prevent the user from repositioning the cursor
           (let ([key (send event get-key-code)])
             (for/or ([dump (list 'left 'right 'up 'down
                                  'end 'home #\rubout)])
               (eq? key dump))))
         (define/override (on-subwindow-char receiver event)
           (or (send this on-system-menu-char event)
               (send this on-dump-keys event)
               (send this on-traverse-char event))))
       [label "Spitter"]
       [min-width 600]
       [min-height 30]
       [stretchable-width #f]
       [stretchable-height #f]
       [style (list 'fullscreen-button)]))

(define pane (new horizontal-pane% [parent frame]))

(define spitter
  ;; Main text entry object
  (new (class text%
         (super-new)
         (define/augment (can-delete? s l)
           ;; Currenltly permitting only a word deletion
           (let ([c (send this get-character s)])
             (if (or (eq? c #\newline) (eq? c #\space))
                 #f
                 #t)))
         (define/override (on-default-event event) (void)) ;Eliminate any mouse events
         (define/public (spit)
           ;; Make sure the text ends with a newline:
           (if (eq? (send this get-character (send this get-end-position)) #\newline)
               (void)
               (send this insert #\newline))
           ;; Make a double newline between paragraphs
           (for ([i (send this find-string-all (string #\newline) 'backward)])
             (send this insert #\newline i))
           (call-with-output-file "output" #:exists 'append
             (λ (out)
               (send this save-port out 'text)))
           (send this erase)))))

(define keymap (new keymap%))
(send keymap add-function "spit" (λ (in event) (send in spit)))
(send keymap map-function "c:s" "spit")

(send spitter set-keymap keymap)

(define editor-canvas
  (new editor-canvas%
       [parent pane]
       [editor spitter]
       [style (list 'no-border 'hide-hscroll 'hide-vscroll 'transparent)]))

(send frame show #t)
