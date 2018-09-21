;Escribir 
;una única regla
;en clips que, dada una lista de números, obtenga una nueva lista en la que 
;se reemplace por un 0 todos aquellos números cuyo valor no coincida con su orden de posición 
;(asumiendo que el primer número a la izquierda ocupa la posición uno). Por ejemplo, dada la lista 
;(lista  15  2  4  6  5  3  7  8  15), obtendría la lista (lista  0  2  0  0  5  0  7  8  0)

(deffacts datos
        (lista 15 2 4 6 5 3 7 8 15)
)

(defrule quitar
        ?f <- (lista $?x ?y $?z)
        (test ( <> (+ (length$ $?x) 1) ?y))
        (test (<> ?y 0))
        =>
        (retract ?f)
        (assert (lista $?x 0 $?z))
        )