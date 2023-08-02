(defsystem :xmltags
  :description "write html with as much lisp as possible"
  :version "0.0.2"
  :author "Alonzo Bazaar <alonzo.lo.stronzo@protonmail.com>"
  :components ((:file "packages")
               (:file "keyparse" :depends-on ("packages"))
               (:file "tagspec" :depends-on ("packages"))
               (:file "xmlprint" :depends-on ("packages"))
               (:file "xmltags" :depends-on ("packages" "xmlprint" "keyparse"))
               (:file "tagenvs" :depends-on ("packages" "xmltags"))
               ))
