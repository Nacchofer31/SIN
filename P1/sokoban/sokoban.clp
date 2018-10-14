(deffacts sokoban
    (robot 3 3 action level 0 boxes b 3 2 b 3 4 stores s 3 5 0 s 4 2 0)
    (obs 2 3)
    (obs 5 2)
    (obs 4 4)
    (obs 5 4)
    (map 5 5)

    ;;  | | | | | |
    ;;  | | |B|S|O|
    ;;  | |O|R| | |
    ;;  | | |B|O|O|
    ;;  | | |S| | |

    (max_steps 10)
)

(defrule move_up
    (robot ?x ?y ?action level ?l boxes $?boxes stores $?stores)
    (max_steps ?steps)
    (map ?mx ?my)

    (test (neq ?action move_down))
    (test (> ?y 1)) ;; Check no top limit
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
    (test (> ?x 1)) ;; Check no left limit
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

(defrule push_up
    (robot ?x ?y ?action level ?l boxes $?boxes stores $?stores)
    (map ?mx ?my)
    (max_steps ?steps)


    (test (> ?y 2))
    (not  (obs ?x =(- ?y 2)))
    (test (member$ (create$ b ?x (- ?y 1)) $?boxes))
    (test (not (member$ (create$ s ?x (- ?y 1)) $?stores)))
    (test (not (member$ (create$ s ?x (- ?y 2)) $?stores)))
    (test (not (member$ (create$ b ?x (- ?y 2)) $?boxes)))
    (test (< ?l ?steps))
    =>
    (bind ?boxes (replace-member$ $?boxes (create$ b ?x (- ?y 2)) (create$ b ?x (- ?y 1))))
    (assert (robot ?x (- ?y 1) push_up level (+ ?l 1) boxes $?boxes stores $?stores))
)

(defrule push_down
    (robot ?x ?y ?action level ?l boxes $?boxes1 b $?boxes stores $?stores)
    (map ?mx ?my)
    (max_steps ?steps)

    (test (< ?y (- ?my 1)))
    (not  (obs ?x =(+ ?y 2)))
    (test (member$ (create$ b ?x (+ ?y 1)) $?boxes))
    (test (not (member$ (create$ s ?x (+ ?y 1)) $?stores)))
    (test (not (member$ (create$ s ?x (+ ?y 2)) $?stores)))
    (test (not (member$ (create$ b ?x (+ ?y 2)) $?boxes)))
    (test (< ?l ?steps))
    =>
    (bind ?boxes (replace-member$ $?boxes (create$ b ?x (+ ?y 2)) (create$ b ?x (+ ?y 1))))
    (assert (robot ?x (+ ?y 1) push_down level (+ ?l 1) boxes $?boxes stores $?stores))
)

(defrule push_left
    (robot ?x ?y ?action level ?l boxes $?boxes stores $?stores)
    (map ?mx ?my)
    (max_steps ?steps)

    (test (> ?x 2))
    (not  (obs =(- ?x 2) ?y))
    (test (member$ (create$ b (- ?x 1) ?y) $?boxes))
    (test (not (member$ (create$ s (- ?x 1) ?y) $?stores)))
    (test (not (member$ (create$ b (- ?x 2) ?y) $?stores)))
    (test (not (member$ (create$ b (- ?x 2) ?y) $?boxes)))
    (test (< ?l ?steps))
    =>
    (bind ?boxes (replace-member$ $?boxes (create$ b (- ?x 2) ?y) (create$ b (- ?x 1) ?y)))
    (assert (robot (- ?x 1) ?y push_left level (+ ?l 1) boxes $?boxes stores $?stores))
)

(defrule push_right
    (robot ?x ?y ?action level ?l boxes $?boxes stores $?stores)
    (map ?mx ?my)
    (max_steps ?steps)

    (test (< ?x (- ?mx 1)))
    (not  (obs =(+ ?x 2) ?y))
    (test (member$ (create$ b (+ ?x 1) ?y) $?boxes))
    (test (not (member$ (create$ s (+ ?x 1) ?y) $?stores)))
    (test (not (member$ (create$ b (+ ?x 2) ?y) $?stores)))
    (test (not (member$ (create$ b (+ ?x 2) ?y) $?boxes)))
    (test (< ?l ?steps))
    =>
    (bind ?boxes (replace-member$ $?boxes (create$ b (+ ?x 2) ?y) (create$ b (+ ?x 1) ?y)))
    (assert (robot (+ ?x 1) ?y push_right level (+ ?l 1) boxes $?boxes stores $?stores))
)

(defrule place_up
    (robot ?x ?y ?action level ?l boxes $?boxes stores $?stores)
    (map ?mx ?my)
    (max_steps ?steps)

    (test (member$ (create$ b ?x (- ?y 1) ) $?boxes))
    (test (member$ (create$ s ?x (- ?y 2) 0) $?stores))
    (test (< ?l ?steps))
    =>
    (bind $?boxes (delete-member$ $?boxes (create$ b ?x (- ?y 1) )))
    (bind $?stores (replace-member$ $?stores (create$ s ?x (- ?y 2) 1) (create$ s ?x (- ?y 2) 0)))
    (assert (robot ?x (- ?y 1) place_up level (+ ?l 1) boxes $?boxes stores $?stores))
)

(defrule place_down
    (robot ?x ?y ?action level ?l boxes $?boxes stores $?stores)
    (map ?mx ?my)
    (max_steps ?steps)

    (test (member$ (create$ b ?x (+ ?y 1) ) $?boxes))
    (test (member$ (create$ s ?x (+ ?y 2) 0) $?stores))
    (test (< ?l ?steps))
    =>
    (bind $?boxes (delete-member$ $?boxes (create$ b ?x (+ ?y 1) )))
    (bind $?stores (replace-member$ $?stores (create$ s ?x (+ ?y 2) 1) (create$ s ?x (+ ?y 2) 0)))
    (assert (robot ?x (+ ?y 1) place_down level (+ ?l 1) boxes $?boxes stores $?stores))
)

(defrule place_left
    (robot ?x ?y ?action level ?l boxes $?boxes stores $?stores)
    (map ?mx ?my)
    (max_steps ?steps)

    (test (member$ (create$ b (- ?x 1) ?y ) $?boxes))
    (test (member$ (create$ s (- ?x 2) ?y 0) $?stores))
    (test (< ?l ?steps))
    =>
    (bind $?boxes (delete-member$ $?boxes (create$ b (- ?x 1) ?y) ))
    (bind $?stores (replace-member$ $?stores (create$ s (- ?x 2) ?y 1) (create$ s (- ?x 2) ?y 0)))
    (assert (robot (- ?x 1) ?y place_left level (+ ?l 1) boxes $?boxes stores $?stores))
)

(defrule place_right
    (robot ?x ?y ?action level ?l boxes $?boxes stores $?stores)
    (map ?mx ?my)
    (max_steps ?steps)

    (test (member$ (create$ b (+ ?x 1) ?y ) $?boxes))
    (test (member$ (create$ s (+ ?x 2) ?y 0) $?stores))
    (test (< ?l ?steps))
    =>
    (bind $?boxes (delete-member$ $?boxes (create$ b (+ ?x 1) ?y) ))
    (bind $?stores (replace-member$ $?stores (create$ s (+ ?x 2) ?y 1) (create$ s (+ ?x 2) ?y 0)))
    (assert (robot (+ ?x 1) ?y place_right level (+ ?l 1) boxes $?boxes stores $?stores))
)

(defrule win
    (declare (salience 100))
    (robot ?x ?y ?action level ?l boxes $?boxes stores $?stores)
    (test (= (length $?boxes) 0))
    =>
    (printout t "Found solution at level: " ?l crlf)
)