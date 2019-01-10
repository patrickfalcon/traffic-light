#lang racket

;; Arduino Manager Library
;; Controlling the GPIO using AsipMain.rkt
;; Patrick Falcon M00668092
;; Ana Catarina Cardoso M00634184
;; Smith Rajesh D'Britto M00689896
;; Rojaht Sipan M00643413

(require "AsipMain.rkt")
(require json)

(display (string-append "\n[ - ] Preparing to compile [ - ]\n "))

;; Simple version check to avoid using the wrong version
;; of Racket. Causes errors within the AsipMain.rkt file
(cond
  ((string-contains? (version) "7.")
   (raise "Please use version 6.X!")
   )
  )

(provide
 ports
 set-ports
 connect
 c
 turnOff
 turnOn
 testAll
 pushed
 disconnect
 inverse
 in
 out
 h
 l
 physInput?
 get-amber
 get-green)

;; List of all ports that are being used
;; Example: '(1 2 3 4)
(define ports '())
(define inputs '())

;; Simplified INPUT_PULLUP_MODE and OUTPUT_MODE
(define in INPUT_PULLUP_MODE)
(define out OUTPUT_MODE)
(define h HIGH)
(define l LOW)

;; Gets the inverse of each of the arguments
;; that should be used
(define inverse (λ (v1)
                  (cond
                    ((equal? v1 HIGH) LOW)
                    ((equal? v1 LOW) HIGH)
                    ((equal? v1 OUTPUT_MODE) INPUT_PULLUP_MODE)
                    ((equal? v1 INPUT_PULLUP_MODE) OUTPUT_MODE)
                    ((equal? v1 h) l)
                    ((equal? v1 l) h)
                    ((equal? v1 in) out)
                    ((equal? v1 out) in)
                    )
                  )
  
  )

(define disconnect (λ ()
                     (close-asip)
                     (display (string-append "\n[ - ] Disconnected from ASIP [ - ]\n ")))
  )

;; Pushed is for user input
(define pushed 0)

;; To replace the digital write
;; Makes it easier to type
(define c (λ (v1 v2)
            (digital-write v1 v2)
            )
  )

(define testAll (λ ()
                  (display (string-append "\n[ - ] Turning on all available ports [ - ]\n "))
                  (turnOn)
                  (sleep 0.25)
                  (turnOff)
                  (display (string-append "\n[ - ] Test completed [ - ]\n "))
                  )
  )

(define changeState (λ (v1)
                      )
  )

;; Puts power to high for all registered output ports
(define turnOn (λ ()
                 (for ([i ports])
                   (c i HIGH)
                   )
                 )
  )

;; Test for physical input (AKA button)
(define physInput? (λ()
                    (cond
                      ((equal? pushed 1) #t)
                      (#t #f))
                    )
  )

;; Puts power to low for all registered output ports
(define turnOff (λ ()
                  (for ([i ports])
                    (c i LOW)
                    )
                  )
  )

(define readFile null)

(define loadSimulation (λ (file) (
                                  (set! readFile (call-with-input-file file read-json))
                                  (hash-ref readFile 'weatherCode)
                                  )
                         )
  )
                         

;; Setting output ports before we can connect
(define set-ports (λ (v1 v2)
                    (for ([i v1])
                      (set-pin-mode! i v2)
                      )
                    (set! ports v1)
                    )
  )


;; Connects with the AsipMain.rkt
(define connect (λ ()
                  (display (string-append "\nPorts: "))
                  (display (number->string (length ports)))
                  (display (string-append "\n----------\nLIGHTS READY"))
                  (open-asip)
                  )
  )

;; Push button test
;; Simulate button press for testing purposes
(define pushButton (λ ()
                     (cond
                       ((equal? pushed 1) "BUTTON ALREADY PUSHED")
                       (#t
                        (set! pushed 1)
                        (display (string-append "\n[BUTTON PRESSED]\n"))
                        (sleep 2)
                        (display (string-append "\n[BUTTON RELEASED]\n"))
                        (set! pushed 0))
                       )
                     )
  )

;; Calculates which GPIO is being used for which light
(define lighti (λ (v1)
                 (display (string-append "\nRED:"))
                 (display (string-append (number->string v1)))
                 (display (string-append "\n"))
                 (display (string-append "AMBER:"))
                 (display (string-append (number->string (- v1 2))))
                 (display (string-append "\nGREEN:"))
                 (display (string-append (number->string (- v1 3))))
                 )
  )

(define get-amber (λ (v1)
                    (- v1 2)
                    )
  )

(define get-green (λ (v1)
                    (- v1 3)
                    ))

(display (string-append "\n[ - ] Compiled Arduino Manager successfully [ - ]\n "))
 