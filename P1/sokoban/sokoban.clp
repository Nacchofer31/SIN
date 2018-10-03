(deffacts sokoban
(robot 3 3 action level 0 boxes b 2 3 stores s 3 4 0)
(obs 3 2)
(obs 4 2)
(obs 5 2)
(obs 4 4)
(obs 5 4)
(map 5 5)

;;  | | | | | |
;;  | | |B|O|O|
;;  | |O|R| | |
;;  | | |S|O|O|
;;  | | | | | |

(max_steps 20)
)

(defrule move_up
(robot ?x ?y ?action level ?l boxes $?boxes stores $?stores)
(max_steps ?steps)
(map ?mx ?my)

(test (neq ?action move_down))
(test (> ?y 0)) ;; Not move top limit
(not (exists (obs ?x =(- ?y 1)))) ;; Check no obs top
(test (not (member$ (create$ b ?x (- ?y 1)) $?boxes))) ;; Check no boxes top
(test (not (member$ (create$ s ?x (- ?y 1)) $?stores))) ;; Check no stores top
(test (< ?l ?steps))
=>
(assert (robot ?x (- ?y 1) move_up level (+ ?l 1) boxes $?boxes stores $?stores ))
)

(defrule move_right
(robot ?x ?y ?action level ?l boxes $?boxes stores $?stores)
(max_steps ?steps)
(map ?mx ?my)

(test (neq ?action move_left))
(test (< ?x ?mx)) ;; Not move right limit
(not (exists (obs =(+ ?x 1) ?y)))
(test (not (member$ (create$ b (+ ?x 1) ?y) $?boxes)))
(test (not (member$ (create$ s (+ ?x 1) ?y) $?stores)))
(test (< ?l ?steps))
=>
(assert (robot (+ ?x 1) ?y move_right level (+ ?l 1) boxes $?boxes stores $?stores))
)

(defrule move_left
(robot ?x ?y ?action level ?l boxes $?boxes stores $?stores)
(max_steps ?steps)
(map ?mx ?my)

(test (neq ?action move_right))
(test (> ?x 0)) ;; Not move left limit
(not (exists (obs =(- ?x 1) ?y)))
(test (not (member$ (create$ b (- ?x 1) ?y) $?boxes)))
(test (not (member$ (create$ s (- ?x 1) ?y) $?stores)))
(test (< ?l ?steps))
=>
(assert (robot (- ?x 1) ?y move_left level (+ ?l 1) boxes $?boxes stores $?stores))
)

(defrule move_down
(robot ?x ?y ?action level ?l boxes $?boxes stores $?stores)
(map ?mx ?my)
(max_steps ?steps)

(test (neq ?action move_up))
(test (< ?y ?my)) ;; Not move down limit
(not (exists (obs ?x =(+ ?y 1)))) ;; Check no obs on bottom
(test (not (member$ (create$ b ?x (+ ?y 1)) $?boxes))) ;; Check no boxes bottom
(test (not (member$ (create$ s ?x (+ ?y 1)) $?stores))) ;; Check no stores bottom
(test (< ?l ?steps))
=>
(assert (robot ?x (+ ?y 1) move_down level (+ ?l 1) boxes $?boxes stores $?stores))
)