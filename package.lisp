;;;; package.lisp

(uiop:define-package #:espeak-ng
  (:use #:cl)
  (:export #:epeak-info
           #:smalltalk
           #:split-phonemes
           #:talk
           #:text-to-phonemes
           #:with-espeak
           #:with-sinsy))
