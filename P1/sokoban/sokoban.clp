(deffacts sokoban
(robot 2 2 box 1 3 store 3 2 level 0)
(obs 1 1)
(obs 3 1)
(map 4 4)
)

(defrule move_up
(robot ?x ?y $?boxes $?stores level ?l)
(map ?mx ?my)
(test (< ?y ?my)) ;;No moverse limite up
=>
(assert (robot ?x (- ?y 1) $?boxes $?stores level (+ ?l 1)))
)

(defrule move_right
(robot ?x ?y $?boxes $?stores level ?l)
(map ?mx ?my)
(test (< ?x ?mx)) ;;No moverse limite right
=>
(assert (robot (+ ?x 1) ?y $?boxes $?stores level (+ ?l 1)))
)

(defrule move_left
(robot ?x ?y $?boxes $?stores level ?l)
(map ?mx ?my)
(test (< ?x 1)) ;;No moverse limite left
=>
(assert (robot (- ?x 1) ?y $?boxes $?stores level (+ ?l 1)))
)

(defrule move_down
(robot ?x ?y $?boxes $?stores level ?l)
(map ?mx ?my)
(test (> ?y 1)) ;;No moverse limite down
=>
(assert (robot ?x (+ ?y 1) $?boxes $?stores level (+ ?l 1)))
)