; CSc 335
; Adding let to the interpreter of chapter 10



;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

; the complete modified interpreter

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

; tls-scheme, from chapter 10 of tls, with let added

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;


; auxiliary functions

(define build
  (lambda (s1 s2)
    (cons s1 (cons s2 (quote ())))))

(define first car)

(define second cadr)

(define third caddr)

(define atom?
  (lambda (x)
    (and (not (pair? x)) (not (null? x)))))



; environments implemented as tables


(define lookup-in-table
  (lambda (name table table-f)
    (cond 
      ((null? table) (table-f name))
      (else (lookup-in-entry name
                             (car table)
                             (lambda (name)
                               (lookup-in-table name
                                                (cdr table)
                                                table-f)))))))

(define extend-table cons)



(define lookup-in-entry
  (lambda (name entry entry-f)
    (lookup-in-entry-help name
                          (names entry)
                          (val entry)
                          entry-f)))



(define lookup-in-entry-help
  (lambda (name names val entry-f)
    (cond
      ((null? names) (entry-f name))
      ((eq? (car names) name) (car val))
      (else (lookup-in-entry-help name
                                  (cdr names)
                                  (cdr val)
                                  entry-f)))))




(define new-entry build)

(define names
  (lambda (entry) (car entry)))

(define val
  (lambda (entry) (cadr entry)))




; the top level of the interpreter

(define value
  (lambda (e)
    (meaning e (quote () ))))


(define meaning
  (lambda (e table)
    ((expression-to-action e) e table)))


; supporting functions for the intepeter

; syntax-directed dispatch on expression

(define expression-to-action
  (lambda (e)
    (cond 
      ((atom? e) (atom-to-action e))
      (else (list-to-action e)))))

(define atom-to-action
  (lambda (e)
    (cond
      ((number? e) *const)
      ((eq? e #t) *const)
      ((eq? e #f) *const)
      ((eq? e (quote cons)) *const)
      ((eq? e (quote car)) *const)
      ((eq? e (quote cdr)) *const)
      ((eq? e (quote null?)) *const)
      ((eq? e (quote eq?)) *const)
      ((eq? e (quote atom?)) *const)
      ((eq? e (quote zero?)) *const)
      ((eq? e (quote add1)) *const)
      ((eq? e (quote sub1)) *const)
      ((eq? e (quote sqr)) *const)
      ((eq? e (quote number?)) *const)
      (else *identifier))))


(define list-to-action
  (lambda (e)
    (cond
      ((atom? (car e))
       (cond 
         ((eq? (car e) (quote quote))
          *quote)
         ((eq? (car e) (quote lambda))
          *lambda)
         ((eq? (car e) (quote cond))
          *cond)
         ;; modified for let
         ((eq? (car e) (quote let))
          *let)
         (else *application)))
      (else *application))))


; operational semantics -- the definitions of the action functions

(define *const
  (lambda (e table)
    (cond 
      ((number? e) e)
      ((eq? e #t) #t)
      ((eq? e #f) #f)
      (else (build (quote primitive) e)))))


(define *quote
  (lambda (e table)
    (text-of e)))

(define text-of second)




(define *identifier
  (lambda (e table)
    (lookup-in-table e table initial-table)))


(define initial-table
  (lambda (name)
    (car (quote ()))))


(define *lambda
  (lambda (e table)
    (build (quote non-primitive)
           (cons table (cdr e)))))


;; let modification

(define *let
  (lambda (e table)
    (let ((associated-lambda-exp 
           (lambda-from-let e)))
      (meaning associated-lambda-exp table))))

;; 



(define table-of first)

(define formals-of second)

(define body-of third)


; cond is a special form that takes any number of 
; cond-lines ...  if it sees an else-line, it treats
; that cond-line as if its question part were true.

(define evcon
  (lambda (lines table)
    (cond 
      ((else? (question-of (car lines)))
       (meaning (answer-of (car lines))
                table))
      ((meaning (question-of (car lines))
                table)
       (meaning (answer-of (car lines))
                table))
      (else (evcon (cdr lines) table)))))


(define else?
  (lambda (x)
    (cond 
      ((atom? x) (eq? x (quote else)))
      (else #f))))

(define question-of first)

(define answer-of second)



(define *cond 
  (lambda (e table)
    (evcon (cond-lines-of e) table)))

(define cond-lines-of cdr)



(define evlis
  (lambda (args table)
    (cond 
      ((null? args) (quote ()))
      (else
       (cons (meaning (car args) table)
             (evlis (cdr args) table))))))



(define *application
  (lambda (e table)
    (myapply
     (meaning (function-of e) table)
     (evlis (arguments-of e) table))))

(define function-of car)

(define arguments-of cdr)

(define a '((lambda (x) (add1 x)) 3))




(define primitive?
  (lambda (l)
    (eq? (first l) (quote primitive))))

(define non-primitive?
  (lambda (l)
    (eq? (first l) (quote non-primitive))))



(define myapply
  (lambda (fun vals)
    (cond
      ((primitive? fun)
       (apply-primitive
        (second fun) vals))
      ((non-primitive? fun)
       (apply-closure
        (second fun) vals)))))

(define add1
  (lambda (x)
    (+ x 1)))


(define apply-primitive
  (lambda (name vals)
    (cond
      ((eq? name (quote cons))
       (cons (first vals) (second vals)))
      ((eq? name (quote car))
       (car (first vals)))
      ((eq? name (quote cdr))
       (cdr (first vals)))
      ((eq? name (quote null?))
       (null? (first vals)))
      ((eq? name (quote eq?))
       (eq? (first vals) (second vals)))
      ((eq? name (quote atom?))
       (:atom? (first vals)))
      ((eq? name (quote zero?))
       (zero? (first vals)))
      ((eq? name (quote add1))
       (add1 (first vals)))
      ((eq? name (quote sub1))
       (sub1 (first vals)))
      ((eq? name (quote number?))
       (number? (first vals)))
      ((eq? name (quote sqr))
      (sqr (first vals))))))


(define :atom?
  (lambda (x)
    (cond 
      ((atom? x) #t)
      ((null? x) #f)
      ((eq? (car x) (quote primitive))
       #t)
      ((eq? (car x) (quote non-primitive))
       #t)
      (else #f))))

(define apply-closure
  (lambda (closure vals)
    (meaning (body-of closure)
             (extend-table
              (new-entry
               (formals-of closure)
               vals)
              (table-of closure)))))


;;;;;;;

; auxilliary functions for let

(define let-vars
  (lambda (e) 
    (map car (cadr e))))


(define let-vals
  (lambda (e)
    (map cadr (cadr e))))


(define let-body
  (lambda (e)
    (caddr e)))



(define lambda-from-let
  (lambda (e)
    (cons
     (list
      'lambda
      (let-vars e)
      (let-body e))
     (let-vals e))))


;;;;;;;;;;;;;;;;;;

(define sample-let-exp-1
  (quote (let ((x 2) (y 3))
           (cons x y))))

(define sample-let-exp-2
  (quote (let ((x 2) (y 3))
           (let ((w 4) (x 5))
             (cons w (cons x y))))))



; optional -- requires PrettyBig language in DrRacket

;(require (lib "trace.ss"))


;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

; try some simple computations to start:

;; (value '7)

;; (value '(add1 6))

;; (value '(cons (quote x) (quote ()))

;; (value '(cons x (quote ())) ) -- for an error

;; (value '((lambda (x) (add1 x)) 3))

;; (value '((lambda (x) (add1 x)) 
;;          ((lambda (x) (add1 x)) 4)))

;; (value '(((lambda (y)
;;            (lambda (x) (cons x y)))
;;          3)
;;         4))


(define let-struct '(let ((x 1)(y 5)) (let (x 5) (add1 x))))
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

; Add a new primitive to TLS!
; I have added the primitive sqr. This primitive will take a single
; parameter and return this parameter squared.

(define sqr
  (lambda (param)
    (* param param)))

; The atom-to-action procedure was modified. The conditional eq? check
; for (quote sqr) was added to the TLS atom-to-action procedure.
; If the question part of this conditional evaluates to true,
; the answer part returns the procedure *const.

; The apply-primitive procedure was modified to look for the type
; (primitive sqr). If this is found in the question part of the
; conditional, the answer part will apply the expected behavior
; of sqr to it's parameter list.

; The initial round of computation results in '(sqr 4) being evaluated
; as a list and therefore list-to-action is called. It is not a special
; non-primitive type so this procedure returns *application.
; Within application, the meaning procedure is called on the func-of '(sqr 4).

; As mentioned earlier, func-of '(sqr 4) returns sqr. Meaning then calls expression-to-action
; again, but this time on just sqr. This is an atom, so it calls the atom-to-action procedure,
; where *const is called next.

; *const returns (primitive sqr). In *application, this return value (primitive sqr) is the
; first parameter of myapply. The second parameter is the procedure call evlis on the (body-of '(sqr 4)).

; The final call is thus -> (myapply '(primitive sqr) '(4)).

; Change the representation of bindings in the system to explicit pairs of the form (name value).

; I need a new file for this...















































































