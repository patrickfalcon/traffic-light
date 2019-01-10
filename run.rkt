#lang racket

(require "AsipMain.rkt")
(require "AMAN.rkt")
(require "TimeManager.rkt")

;; Allows the variables in TimeManager to be executed
(init)

;; Defining the output ports
(define rP 13)
(set-ports '(13, 11, 10) out)

;; Setting the input ports
(set-ports '(2) in)

;; Testing all ports
(testAll)

;; Simple check just so we can avoid the light
;; being in a state of pushed without any physical
;; input actually being received from the button
(cond
  ((physInput?) (display (string-append "\nPHYSICAL INPUT DETECTED BEFORE CALLED! FIX THAT"))
  ))