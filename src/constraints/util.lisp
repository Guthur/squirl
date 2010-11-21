;;;; -*- Mode: Lisp; indent-tabs-mode: nil -*-
(in-package :squirl)

(defun apply-impulses (body1 body2 r1 r2 j)
  (body-apply-impulse body1 (vec- j) r1)
  (body-apply-impulse body2 j r2)
  (values))

(defun k-tensor (body1 body2 r1 r2)
  ;; calculate mass matrix
  ;; C sources say: "If I wasn't lazy and wrote a proper matrix class, this wouldn't be so gross...
  (let* ((mass-sum (+ (body-inverse-mass body1)
                      (body-inverse-mass body2)))

         ;; Start with I*mass-sum
         (k11 mass-sum) (k12 0d0)
         (k21 0d0)        (k22 mass-sum)

         ;; influence from r1
         (b1-inverse-inertia (body-inverse-inertia body1))
         (r1xsq (* (vec-x r1) (vec-x r1) b1-inverse-inertia))
         (r1ysq (* (vec-y r1) (vec-y r1) b1-inverse-inertia))
         (r1nxy (- (* (vec-x r1) (vec-y r1) b1-inverse-inertia)))

         ;; influence from r2
         (b2-inverse-inertia (body-inverse-inertia body2))
         (r2xsq (* (vec-x r2) (vec-x r2) b2-inverse-inertia))
         (r2ysq (* (vec-y r2) (vec-y r2) b2-inverse-inertia))
         (r2nxy (- (* (vec-x r2) (vec-y r2) b2-inverse-inertia))))
    ;; apply influence from r1
    (incf k11 r1ysq) (incf k12 r1nxy)
    (incf k21 r1nxy) (incf k22 r1xsq)

    ;; apply influence from r2
    (incf k11 r2ysq) (incf k12 r2nxy)
    (incf k21 r2nxy) (incf k22 r2xsq)

    ;; invert
    (let ((det-inv (/ (- (* k11 k22) (* k12 k21)))))

      ;; and we're done.
      (values (vec    (* k22 det-inv) (- (* k12 det-inv)))
              (vec (- (* k21 det-inv))   (* k11 det-inv))))))

(defun mult-k (vr k1 k2)
  (vec (vec. vr k1) (vec. vr k2)))

(defun impulse-max (constraint dt)
  (* (constraint-max-force constraint) dt))
