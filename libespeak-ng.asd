;;;; libespeak-ng.asd

(asdf:defsystem #:libespeak-ng
  :description "Describe libespeak-ng here"
  :author "Your Name <your.name@example.com>"
  :license  "Specify license here"
  :version "0.0.1"
  :serial t
  :depends-on (#:cffi)
  :components ((:file "package")
               (:file "libespeak-ng-cffi")
               (:file "libespeak-ng")))
