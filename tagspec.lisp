#|
per attributes check possiamo fare qualcosa come
- nil-attribute
- non-nil-attribute
- no-attributes
- some-attributes
- attribute-among-options
(
e creare una funzione helper che si vede lei la rappresentazione interna, boh.
Je ne sais pas 
|#
(in-package :tagspec)

(defstruct spec
  name
  closep
  newline-before-open
  newline-after-open
  newline-after-close
  attributes-check
  body-check)

(defmacro make-spec-short (name &key closep style)
  "shorthand for when newlines follow a predictable pattern (to be updated once I start taking the attrbute and body checks seriously)"
  (append `(make-spec :name ,name :closep ,closep)
          (case style
            (section '(:newline-before-open t ; html, head, body, div...
                       :newline-after-open t
                       :newline-after-close t))
            (header '(:newline-before-open t ; h1, h2...
                      :newline-after-open nil
                      :newline-after-close t))
            (typeface '(:newline-before-open nil ; bold, italic...
                        :newline-after-open nil
                        :newline-after-close nil)))))

(defparameter *html-spec*
  (list
   (make-spec-short "html" :closep nil :style section)
   (make-spec-short "head" :closep nil :style section)
   (make-spec-short "body" :closep nil :style section)
   (make-spec-short "script" :closep nil :style header)
   (make-spec-short "link" :closep nil :style header)

   (make-spec-short "h1" :closep nil :style header)
   (make-spec-short "h2" :closep nil :style header)
   (make-spec-short "h3" :closep nil :style header)
   (make-spec-short "h4" :closep nil :style header)
   (make-spec-short "ul" :closep nil :style section)
   (make-spec-short "li" :closep nil :style header)

   (make-spec-short "div" :closep nil :style section)
   (make-spec-short "form" :closep nil :style section)))
			   
