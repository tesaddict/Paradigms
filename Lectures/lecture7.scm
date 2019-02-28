
; CSc 335
; Lecture 7 
; March 5 2019

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

; ninth class meeting

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

; The focus is on introducing the material in TLS

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

; Material from TLS, with ideas on inductive definitions, Backus-Naur form and
; box and pointer diagrams added in class

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

; an atom is a string of letters, digits, or characters other than ( or ) - no spaces,
; either

;; atom
;; turkey
;; 1492
;; abc$2


; lists are collections of atoms or lists enclosed by parentheses

;; (atom turkey or)
;; ((atom turkey) or)
;; ()


; atoms and lists both belong to the class of S-expressions --
; here are some more examples

;; ()
;; xyz
;; (x y z)
;; ((x y) z)
;; (())
;; ((() ()) () )



; an s-exp ("s-expression") is either an atom, the empty list, 
; or a list of s-exps

; thus

; ()    is an s-exp

; xyz is an s-exp

; (x y z) is a list of s-exps, and hence an s-exp

; ((x y) z) is a list of two s-exps, (x y) and z, and hence is 
; itself an s-exp


; that is, 

;    s-exp ::=  atom | () | (s-exp ... s-exp)

;; clearly, every atom is an s-exp, and it seems reasonable
;; to say that every list is an s-exp, but as atoms are not
;; themselves lists, it is clear that not every s-exp is a list


; why is (((how) are) ((you) (doing so)) far) an s-exp?  we use
; the definition to break the expression down into its constituents



; can you give a similar inductive definition of lists?  

; what about

;   list ::= () | (atom ... atom) 

; is this sufficiently broad? (no!) If not, can you repair it?  If you are not
; clear on this, don't worry: we will come back to it. 



; functions for lists:  car, cdr and cons


; (car (a b c)) = a

; (car ((a b c) x y z)) = (a b c)

; (car ( ((hotdogs)) (and) (pickle) relish)) = ((hotdogs))

; (car ((hotdogs))) = (hotdogs)

; (car (car ((hotdogs)))) = hotdogs

; (car hotdogs)  --> error

; (car ()) --> error





; (cdr (a b c)) = (b c)

; (cdr ((a b c) x y z) = (x y z)

; (cdr (hamburger)) = ()

; (cdr hotdogs) --> error

; (cdr ()) --> error





; (car (cdr ((b) (x y) ((c))) = (x y)


; (cdr (cdr ((b) (x y) ((c))))) = (((c)))


; (cdr (car (a (b (c)) d)) --> ?



; what does car take as an argument?

; what does cdr take as an argument?


; cons -- at some point, we need to ask how these lists are created in the first place!


; (cons peanut (butter and jelly)) = (peanut butter and jelly)

; (cons (banana and) (peanut butter and jelly)) = ((banana and) peanut butter and jelly)

; (cons ((help) this) (is very (hard) to learn)) = (((help) this) is very (hard) to learn)

; (cons (a b (c)) ()) = 

; (cons a ()) = 

; (cons ((a b c)) b) =


; what does cons take as its arguments?



; cons, car and cdr together

; (cons a (car ((b) c d) ))

; (cons a (cdr((b) c d)  )) 


; in fact, we note that cons, car and cdr satisfy some equations:  

; (car (cons a b)) = a
; (cdr (cons a b)) = b

; can you think of another?

; how about (cons (car (cons a b)) (cdr (cons a b))) = (cons a b)



;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

; many of the car/cdr/cons computations given above can be explained via the simple visual
; device of 'box and pointer' diagrams, as we indicate on the board
; in class.  you can find a discussion of such diagrams in SICP, in Section 2.2 --
; you will want to look at this, as we will be seeing these diagrams off and on throughout
; the rest of the term.

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;








;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;


; now that we have introduced cons, what do you think of the following as a 
; definition of lists?

;; ; list ::= () | (cons list list)

; We need to ask whether this recipe generates _only_ lists (that is, whether
; it is a sound recipe for generating lists), and whether it generates _all_ lists
; (that is, whether it is complete for lists).

; we argue by induction* that it is sound, and note that even this simple recipie
; is capable of generating some complex structures.  

; it is quite easy to see that it is not complete -- for example, the list
; (a) is not generated.

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

; *: induction on what?  In this case, induction on the number of times the rule
; is applied to generate a list.

; A formula such as this can be viewed as a
; generator: starting with (), it generates (cons () ()) at the next level, and then
; (cons () (cons () ())) and (cons (cons () ()) ()) at the next.  Continuing in this
; way, one can enumerate all of the lists generated by this rule.

; But this is no way to verify that everything generated by the rule is in fact a list.
; For that, we need an induction.  So: observe that every object generated by one application
; of the rule is a list -- () and (cons () ()) are both lists.  Next assume that an object
; list, after k applications of the rule, is a list -- that is, the cdr of its final cons
; is ().  Does this hold after one more step?  Clearly, yes: (cons list list) does not
; alter the last cons cell in list. 

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;


; What about taking care of atoms in the way suggested by this next (candidate) definition?

;; list ::= () | (cons atom list) | (cons list list))

; is this sufficiently broad?  is it too broad?  Can we agree that it handles every 
; example we have seen so far, and that everything it generates appears to 
; be a list in the sense we mean, and then to take it as the definition of lists?  

; What good is it to have a definition formulated this way?  The answer jumps out 
; when we consider the problem of designing and proving correct a program which
; processes lists.  Indeed, how could we do this if we did not have a precise
; characterization of the input?


;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

; Here is a suggested homework problem for you:

; Critique, as a definition of the class of lists, 

; list ::= () | (cons atom list) | (cons list (list))

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;


; let us agree for now that anything which is not a list is an atom,
; and that atom? is a predicate which checks whether its single argument
; is an atom.

; (atom? 'atom) 
; (atom? 'turkey)
; (atom? 1492)

; (atom? '(a b c))
; (atom? '())


; the predicate list? checks whether its single argument is a list

; (list? 'atom)
; (list? '(atom))

; (list? '())

; (list? '(a (b c)))


; atom?, list?, car, cdr and cons can of course be used together

; (atom? (car l)), where l is '(Harry had a heap of apples)

; (atom? (cdr l)), for the same l

; (list? (cdr l)), for the same l

; (atom? (car (cdr l))), where l is '(swing low sweet cherry oat)

; and so on



; another useful predicate is pair?, which is more general than list?

; (pair? (cons 'a 'b))

; (pair? (cons 'a (cons 'b '())))

;   note that (cons 'a (cons 'b '())) = '(a b)



; null? is the predicate used to check for the empty list:

; (null? '())



; note that (pair? '()) = #f 



; while null?, pair? and list? are pre-defined in scheme, we must define atom? ourselves.  

; one way of doing this is as follows:

(define atom?
  (lambda (x)
    (and (not (pair? x)) (not (null? x)))))



; another built-in predicate is eq?, scheme's strongest equality predicate.  

; (eq? a1 a2), where a1 is 'Harry and a2 is 'Harry


; (eq? 'margarine 'butter)


; (eq? '() '(strawberry))
  
; (eq? 6 7) 
  
; (eq? (car l) a), where l is (Mary had a little lamb chop) and a is Mary

; (eq? (cdr l) a), where l is (soured milk) and a is milk

; (eq? (car l) (car (cdr l))) where l is (beans beans we need jelly beans)


;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

; eq? checks for pointer identity

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

; what about carrying out some of the car/cdr/cons calculations on the computer?  

;; [some scheme examples shown in class] 

; The thing to keep in mind is, roughly, that scheme
; tries to evaluate everything.  When we ask for (car (a b c)), it will
; evaluate car (to the built-in primitive of the same name), but run into
; trouble when it tries to evaluate (a b c).  Scheme will want to regard
; a as a function, and the values of b and c as arguments to that function.
; But we have not associated a with a function, nor any values at all with
; b or c: for us, the list (a b c) is just a list of symbols.  To get scheme
; to think of it in the same way, we use quote to block evaluation.  Scheme
; will regard (quote (a b c)) as the list of symbols we have in mind.  Thus
; (car (quote (a b c)) = a, and (cdr (quote (a b c)) = (b c), and so on. 

; it is frequently convenient to abbreviate quote by ', the single stroke 
; located under the " symbol on the keypad.  thus we will sometimes write
; (car (cdr '(a b c))) instead of (car (cdr (quote (a b c)))), etc.  

; note that quote plays well with define --

(define x '(a b c))

; sets up x as a name to the list (a b c)



; but observe the effect of quote on evaluation in a more familiar setting:

; if

(define x 1)

; then

x

; evals to 1, while

(quote x)

; evals to the symbol x


;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

; we move on now to develop programs using lists

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;



; Consider lists of atoms


;;  lat ::= () | (cons atom lat)



; Here is a predicate of one argument, lst, which checks whether lst
; is a lat.  Note the structural similarity between this definition
; and the recipe just given.


(define lat?
  (lambda (lst)
    (cond ((null? lst) #t)
          (else 
           (and
            (atom? (car lst)) 
            (lat? (cdr lst)))))))


; (lat? '(bacon and eggs))

; (lat? '(bacon (and eggs)))


; an alternate design, which also corresponds (perhaps not as closely) to the 
; definition

(define alt-lat?
  (lambda (lst)
    (cond ((null? lst) #t)
          ((atom? (car lst)) (alt-lat? (cdr lst)))
          (else #f))))



; what do you make of this?

(define alt-alt-lat?
  (lambda (lst)
    (or (null? lst)
	(and (atom? (car lst))
	     (alt-alt-lat? (cdr lst))))))

; do we _ever_ actually need cond? recall our earlier discussion:  cond is a special form,
; and we have seen examples where it is absolutely necessary.  Even here, the success of 
; this last definition depends on the implementation's evaluation order for or -- if one
; were to modfiy the 'short-circuit' implementation of or, the function might well fail.
; As the logical definition of or does not depend on the evaluation order of its arguments,
; it is perhaps poor style (in the sense of violating abstraction barriers) to depend on
; this implementation detail so heavily as in this function.





;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

; correctness of lat?, as well as alt-lat?,  can  be established by 
; induction on the length of lst.

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

; any claim of correctness requires a specification:

;   pre:  lst is a list
;
;   post: (lat? lst) = #t when lst is a list of atoms
;                      #f otherwise

; said another way, the post-condition for (lat? lst) is just 'lst is a list of atoms'

; so: one shows by induction on the length of lst that lat? satisfies
; this specification: if the input parameter lst is in fact a list, then 
; (lat? lst) returns #t iff lst is a list of atoms.  Nothing is promised
; if the input parameter is not a list. 

; we sketch this argument in class, and ask you to write it up for practice

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
