;;; questi poi andrò a metterli in altri package
;;; schema definition (an html schema, an svg schema, a dae schema, I dunno)
#|
lo schema includerà i tipi di tag, a ogni tag saranno associati flag quali :
- sono aperti o meno
- direttive di "pretty printing" (dove mettere i newline quando le stampi, opzionale, di default non mette nessun newline)
- TODO : check su che argomenti può avere / non avere
- TODO : check su che tipi di sottotag può avere / non avere
- TODO : fai che se il body è vuoto viene renderizzata come una tag vuota
fattibile anche con un (if (null children) (setf closep t)) tra il multiple-value-bind e il progn
|#


(in-package :xmltags)

(defun should-print-p (elt)
  "we'd like to be able to write things like (ul (li \"hello\") (li \"world\")) in the templates, to keep the template synthax short, though, to allow this we must have a way to make the program decide \"should I print this or just evaluate it?\", ergo this function"
  (or (stringp elt)
      (numberp elt)
      (characterp elt)))

;; this one thing
;; this gigantic, lovecraftian, thing
;; t'is the beating hearth of this whole library
;; of this whole program
;; of this whole paradigm of "just execute the xml"
(defmacro with-tag (tagstr body &optional (closep nil)
                                  (newline-before-open nil)
                                  (newline-after-open nil)
                                  (newline-after-close nil))
  ;; parameterize the tag printing code (this is, I'm aware, rather awful)
    (let ((opening-open-sequence `(progn
             (when ,newline-before-open (xml-newline))
             (xml-princ ,(format nil "<~A" tagstr))))
           (opening-close-sequence `(progn
             (xml-princ ">")
             (when ,newline-after-open (xml-newline))))
           (closing-sequence `(progn
             (xml-princ ,(format nil "</~A>" tagstr))
             (when ,newline-after-close (xml-newline)))))

    (multiple-value-bind (attributes children) (split-kwargs body)
      (when closep (assert (null children)))
      `(progn
         ,opening-open-sequence
         ;; attributes, passed as an alist
         (when ',attributes (xml-princ " "))
         ,@(mapcar (lambda (attr-pair)
                     `(let ((key ,(car attr-pair))
                            (val ,(cdr attr-pair)))
                        (xml-format "~A = \"~A\"" key val)))
                   attributes)
         ,opening-close-sequence

         ;; body
         ,@(mapcar (lambda (child)
                     `(let ((sub ,child))
                        (when (should-print-p sub) (xml-princ sub))))
                   children)
         ,closing-sequence))))
