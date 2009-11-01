;;;; -*- Mode: Lisp; indent-tabs-mode: nil -*-
(in-package :squirl)

(declaim (optimize speed safety))

(deftype vec ()
  '(cons real real))

(declaim (ftype (function (real real) vec) vec))
(defun vec (x y)
  (cons x y))

(declaim (ftype (function (vec) real) vec-x vec-y))
(defun vec-x (vec)
  (car vec))
(defun vec-y (vec)
  (cdr vec))

(defconstant +zero-vector+ (vec 0 0))

(defun vec-length (vec)
  (sqrt (vec. vec vec)))

;; TODO - Am I sure C uses radians, like lisp?
(defun angle->vec (angle)
  "Convert radians to a normalized vector"
  (vec (cos angle)
       (sin angle)))

(defun vec->angle (vec)
  "Convert a vector to radians."
  (atan (vec-y vec)
        (vec-x vec)))

(defun vec+ (v1 v2)
  (vec (+ (vec-x v1)
             (vec-x v2))
          (+ (vec-y v1)
             (vec-y v2))))

(defun vec-neg (vec)
  (vec (- (vec-x vec))
          (- (vec-y vec))))

(defun vec- (v1 v2)
  (vec (- (vec-x v1)
             (vec-x v2))
          (- (vec-y v1)
             (vec-y v2))))

(defun vec* (vec s)
  (vec (* (vec-x vec) s)
          (* (vec-y vec) s)))

(defun vec. (v1 v2)
  "Dot product of two vectors"
  (+
   (* (vec-x v1)
      (vec-x v2))
   (* (vec-y v1)
      (vec-y v2))))

(defun vecx (v1 v2)
  "Cross product of two vectors"
  (-
   (* (vec-x v1)
      (vec-y v2))
   (* (vec-y v1)
      (vec-x v2))))

(defun vec-perp (vec)
  (vec (- (vec-y vec))
          (vec-x vec)))

(defun vec-rperp (vec)
  (vec (vec-y vec)
          (- (vec-x vec))))

(defun vec-project (v1 v2)
  (vec* v2 (/ (vec. v1 v2)
              (vec. v2 v2))))

(defun vec-rotate (v1 v2)
  (vec (- (* (vec-x v1)
                (vec-x v2))
             (* (vec-y v1)
                (vec-y v2)))
          (+ (* (vec-x v1)
                (vec-y v2))
             (* (vec-y v1)
                (vec-x v2)))))

(defun vec-unrotate (v1 v2)
  (vec (+ (* (vec-x v1)
                (vec-x v2))
             (* (vec-y v1)
                (vec-y v2)))
          (- (* (vec-y v1)
                (vec-x v2))
             (* (vec-x v1)
                (vec-y v2)))))

(defun vec-length-sq (vec)
  (vec. vec vec))

(defun vec-lerp (v1 v2 ratio)
  (vec+
   (vec* v1 (- 1 ratio))
   (vec* v2 ratio)))

(defun vec-normalize (vec)
  (vec* vec (/ 1 (vec-length vec))))

(defun vec-normalize-safe (vec)
  (if (and (= 0 (vec-x vec))
           (= 0 (vec-y vec)))
      +zero-vec+
      (vec-normalize vec)))

(defun vec-clamp (vec len)
  (if (> (vec. vec vec)
         (* len len))
      (vec* (vec-normalize vec) len)
      vec))

(defun vec-dist (v1 v2)
  (vec-length (vec- v1 v2)))

(defun vec-dist-sq (v1 v2)
  (vec-length-sq (vec- v1 v2)))

(defun vec-near (v1 v2 dist)
  (< (vec-dist-sq v1 v2)
     (* dist dist)))