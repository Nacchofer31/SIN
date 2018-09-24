(defrule derecha
(hanoi $?x tower ?t ?d1 $?medio tower ?t2 $?resto)
(test (neq ?d1 tower))
(test (or (= 0 (length$ $?resto)) (eq (nth$ 1 $?resto)tower)(< ?d1(nth$ 1 $?resto))))
=> (assert (hanoi $?x tower ?t $?medio tower ?t2 ?d1 $?resto))