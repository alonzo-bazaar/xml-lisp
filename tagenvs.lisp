(in-package :tagenvs)

(defun downsym (sym) (string-downcase (symbol-name sym)))

;; for global tag definitions
(defmacro deftag (name &optional
                  (closep nil)
                  (newline-before-open nil)
                  (newline-after-open nil)
                  (newline-after-close nil))
   `(defmacro ,name (&rest body)
   (list 'with-tag ,(downsym name) body ,closep
         ,newline-before-open
         ,newline-after-open
         ,newline-after-close)))

;; for local tag definitions
;; (to be replaced with a function generating a tag macrolet from a tag spec struct
;; because I didn't make those tag specs for nothing)
(defun lettag (tagsym &rest body)
  `(,tagsym (&rest body) (list 'with-tag ,(downsym tagsym) body ,@body)))

(defmacro with-html (&rest body)
  `(macrolet
       (
        ,(lettag 'html nil t t t)

        ,(lettag 'head nil t t t)
        ,(lettag 'body nil t t t)

        ,(lettag 'meta nil t nil t)
        ,(lettag 'title nil t nil t)
        ,(lettag 'script nil t nil t)

        ,(lettag 'div nil t t t)

        ,(lettag 'h1 nil t nil t)
        ,(lettag 'h2 nil t nil t)
        ,(lettag 'h3 nil t nil t)
        ,(lettag 'h4 nil t nil t)

        ,(lettag 'p nil nil nil t)
        ,(lettag 'a nil nil nil nil)
        ,(lettag 'img t nil nil nil)

        ,(lettag 'ul nil t t t)
        ,(lettag 'li nil t nil t)
        )
     ,@body))
