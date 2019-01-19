;;;; espeak-ng.asd

(asdf:defsystem #:espeak-ng
  :description "Describe espeak-ng here"
  :author "Your Name <your.name@example.com>"
  :license  "Specify license here"
  :version "0.0.1"
  :serial t
  :depends-on (#:cffi
               #:cl-ppcre)
  :components ((:file "package")
               (:file "espeak-ng-cffi")
               (:file "espeak-ng")))
