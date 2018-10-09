(deffacts sokoban
    (robot 3 3 action level 0 boxes b 3 2 b 3 1 stores s 3 4 0)
    (obs 2 3)
    (obs 4 2)
    (obs 5 2)
    (obs 4 4)
    (obs 5 4)
    (map 5 5)

    ;;  | | |B| | |
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
    (test (> ?y 0)) ;; Check no top limit
    (not (obs ?x =(- ?y 1))) ;; Check no obs above
    (test (not (member$ (create$ b ?x (- ?y 1)) $?boxes))) ;; Check no boxes above
    (test (not (member$ (create$ s ?x (- ?y 1)) $?stores))) ;; Check no stores above
    (test (< ?l ?steps))
    =>
    (assert (robot ?x (- ?y 1) move_up level (+ ?l 1) boxes $?boxes stores $?stores ))
)

(defrule move_left
    (robot ?x ?y ?action level ?l boxes $?boxes stores $?stores)
    (max_steps ?steps)
    (map ?mx ?my)

    (test (neq ?action move_right))
    (test (> ?x 0)) ;; Check no left limit
    (not  (obs =(- ?x 1) ?y)) ;; Check no obs left
    (test (not (member$ (create$ b (- ?x 1) ?y) $?boxes))) ;; Check no box left
    (test (not (member$ (create$ s (- ?x 1) ?y) $?stores))) ;; Check no store left
    (test (< ?l ?steps))
    =>
    (assert (robot (- ?x 1) ?y move_left level (+ ?l 1) boxes $?boxes stores $?stores))
)

(defrule move_right
    (robot ?x ?y ?action level ?l boxes $?boxes stores $?stores)
    (max_steps ?steps)
    (map ?mx ?my)

    (test (neq ?action move_left))
    (test (< ?x ?mx)) ;; Check no right limit
    (not  (obs =(+ ?x 1) ?y)) ;; Check no obs right
    (test (not (member$ (create$ b (+ ?x 1) ?y) $?boxes))) ;; Check no box right
    (test (not (member$ (create$ s (+ ?x 1) ?y) $?stores))) ;; Check no store right
    (test (< ?l ?steps))
    =>
    (assert (robot (+ ?x 1) ?y move_right level (+ ?l 1) boxes $?boxes stores $?stores))
)

(defrule move_down
    (robot ?x ?y ?action level ?l boxes $?boxes stores $?stores)
    (map ?mx ?my)
    (max_steps ?steps)

    (test (neq ?action move_up))
    (test (< ?y ?my)) ;; Not move down limit
    (not  (obs ?x =(+ ?y 1))) ;; Check no obs on bottom
    (test (not (member$ (create$ b ?x (+ ?y 1)) $?boxes))) ;; Check no box bottom
    (test (not (member$ (create$ s ?x (+ ?y 1)) $?stores))) ;; Check no store bottom
    (test (< ?l ?steps))
    =>
    (assert (robot ?x (+ ?y 1) move_down level (+ ?l 1) boxes $?boxes stores $?stores))
)

(defrule push_top
    (robot ?x ?y ?action level ?l boxes $?boxes1 b ?bx ?by $?boxes2 stores $?stores)
    (map ?mx ?my)
    (max_steps ?steps)

    (test (> ?y 2))
    (test (eq ?bx ?x))
    (test (eq ?by (- ?y 1)))
    (not  (obs ?x =(- ?y 2)))
    (test (not (member$ (create$ s ?x (- ?y 1)) $?stores)))
    (test (not (member$ (create$ s ?x (- ?y 2)) $?stores)))
    (test (not (member$ (create$ b ?x (- ?y 2)) $?boxes1)))
    (test (not (member$ (create$ b ?x (- ?y 2)) $?boxes2)))
    (test (< ?l ?steps))
    =>
    (assert (robot ?x (- ?y 1) push_top level (+ ?l 1) boxes $?boxes1 b ?bx (- ?by 1) $?boxes2 stores $?stores))
)

(defrule push_left
    (robot ?x ?y ?action level ?l boxes $?boxes1 b ?bx ?by $?boxes2 stores $?stores)
    (map ?mx ?my)
    (max_steps ?steps)

    (test (> ?x 2))
    (test (eq ?by ?y))
    (test (eq ?bx (- ?x 1)))
    (not  (obs =(- ?x 2) ?y))
    (test (not (member$ (create$ s (- ?x 1) ?y) $?stores)))
    (test (not (member$ (create$ s (- ?x 2) ?y) $?stores)))
    (test (not (member$ (create$ b (- ?x 2) ?y) $?boxes1)))
    (test (not (member$ (create$ b (- ?x 2) ?y) $?boxes2)))
    (test (< ?l ?steps))
    =>
    (assert (robot (- ?x 1) ?y push_left level (+ ?l 1) boxes $?boxes1 b (- ?bx 1) ?by $?boxes2 stores $?stores))
)

(defrule push_right
    (robot ?x ?y ?action level ?l boxes $?boxes1 b ?bx ?by $?boxes2 stores $?stores)
    (map ?mx ?my)
    (max_steps ?steps)

    (test (< ?x (- ?mx 2)))
    (test (eq ?by ?y))
    (test (eq ?bx (+ ?x 1)))
    (not  (obs =(+ ?x 2) ?y))
    (test (not (member$ (create$ s (+ ?x 1) ?y) $?stores)))
    (test (not (member$ (create$ s (+ ?x 2) ?y) $?stores)))
    (test (not (member$ (create$ b (+ ?x 2) ?y) $?boxes1)))
    (test (not (member$ (create$ b (+ ?x 2) ?y) $?boxes2)))
    (test (< ?l ?steps))
    =>
    (assert (robot (+ ?x 1) ?y push_right level (+ ?l 1) boxes $?boxes1 b (+ ?bx 1) ?by $?boxes2 stores $?stores))
)

(defrule push_down
    (robot ?x ?y ?action level ?l boxes $?boxes1 b ?bx ?by $?boxes2 stores $?stores)
    (map ?mx ?my)
    (max_steps ?steps)

    (test (< ?y (- ?my 2)))
    (test (eq ?bx ?x))
    (test (eq ?by (+ ?y 1)))
    (not  (obs ?x =(+ ?y 2)))
    (test (not (member$ (create$ s ?x (+ ?y 1)) $?stores)))
    (test (not (member$ (create$ s ?x (+ ?y 2)) $?stores)))
    (test (not (member$ (create$ b ?x (+ ?y 2)) $?boxes1)))
    (test (not (member$ (create$ b ?x (+ ?y 2)) $?boxes2)))
    (test (< ?l ?steps))
    =>
    (assert (robot ?x (+ ?y 1) push_down level (+ ?l 1) boxes $?boxes1 b ?bx (+ ?by 1) $?boxes2 stores $?stores))
)