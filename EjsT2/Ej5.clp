(defglobal ?*contador* = 0)
(defrule contar
    (boleto-ganador $? ?x  $?)
    (combinacion $? ?x $?)
    =>
    (bind ?*contador* (+ ?*contador* 1 ))
    )

;; Otra forma de implementarlo

(contador 0)
(defrule contar2
    ?b <- (boleto-ganador $?x1 ?x $?x2)
    ?c <- (contador $?x3 ?x $?x4)
    ?a <- (contador ? )
    => (retract ?a ?b ?c)
    (assert (contador (+ ?c 1))
    (assert (boleto-ganador $?x1 $?x2))
    (assert (combinacion $?x3 $?x4)))
    )