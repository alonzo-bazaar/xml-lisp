(in-package :xmlprint)

(defparameter *xml-out-stream* *standard-output*
  "e con questa se mai dobbiamo fare rendering a stringa basterà fare (let (*xml-out-stream (make-string-out-stream-qualcosa ...)) (stampa roba a *xml-out-stream*))")
(defparameter *xml-line-empty-p* t)
(defparameter *xml-indentation* 0)
(defparameter *xml-pretty-print* t)

(defun indent-by (n)
  (dotimes (x n)
    (princ #\Space)))

(defun xml-indent ()
  (indent-by *xml-indentation*))

(defun xml-princ (thing)
  (xml-indent)
  (setf *xml-line-empty-p* nil)
  (princ thing *xml-out-stream*))

(defmacro xml-format (&rest body)
  `(progn
     (xml-indent)
     (setf *xml-line-empty-p* nil)
     (format *xml-out-stream* ,@body)))

(defun xml-newline ()
  (if (and *xml-pretty-print* (not *xml-line-empty-p*))
    (progn
      (setf *xml-line-empty-p* t)
      (terpri *xml-out-stream*))))

(defmacro render-string (&rest body)
  `(with-output-to-string (*xml-out-stream*)
     ,@body))

(defmacro render-to-file (filename &rest body)
  `(with-open-file (*xml-out-stream* ,filename
                              :direction :output
                              :if-exists :supersede)
     ,@body))
