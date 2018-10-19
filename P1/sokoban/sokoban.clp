(defglobal ?*nod-gen* = 0)

(deffunction init ()
        (reset)

    ;;  | | | |O| | |S| |
    ;;  | |B| | | |B| | |
    ;;  |O| | |O|O| | |O|
    ;;  |R| |B|O|S| | | |
    ;;  | | | |O|S| | | |

	(printout t "Profundidad Maxima:= " )
	(bind ?prof (read))
	(printout t "Tipo de Busqueda " crlf "    1.- Anchura" crlf "    2.- Profundidad" crlf )
	(bind ?a (read))
	(if (= ?a 1)
	       then    (set-strategy breadth)
	       else   (set-strategy depth))
        (printout t " Ejecuta run para poner en marcha el programa " crlf)
	(assert (robot 1 4 level 0 boxes b 2 2 b 6 2 b 3 4 stores s 7 1 0 s 5 4 0 s 5 5 0))
    (assert (obs 4 1))
    (assert (obs 1 3))
    (assert (obs 4 3))
    (assert (obs 5 3))
    (assert (obs 8 3))
    (assert (obs 4 4))
    (assert (obs 4 5))
    (assert (map 8 5))
    (assert (max_steps ?prof))
	
)

(defrule move_up
    (robot ?x ?y level ?l boxes $?boxes stores $?stores)
    (max_steps ?steps)
    (map ?mx ?my)

    (test (> ?y 1)) ;; Check no top limit
    (not (obs ?x =(- ?y 1))) ;; Check no obs above
    (test (not (member$ (create$ b ?x (- ?y 1)) $?boxes))) ;; Check no boxes above
    (test (not (member$ (create$ s ?x (- ?y 1)) $?stores))) ;; Check no stores above
    (test (< ?l ?steps))
    =>
    (assert (robot ?x (- ?y 1) level (+ ?l 1) boxes $?boxes stores $?stores ))
    (bind ?*nod-gen* (+ ?*nod-gen* 1))
)

(defrule move_left
    (robot ?x ?y level ?l boxes $?boxes stores $?stores)
    (max_steps ?steps)
    (map ?mx ?my)

    (test (> ?x 1)) ;; Check no left limit
    (not  (obs =(- ?x 1) ?y)) ;; Check no obs left
    (test (not (member$ (create$ b (- ?x 1) ?y) $?boxes))) ;; Check no box left
    (test (not (member$ (create$ s (- ?x 1) ?y) $?stores))) ;; Check no store left
    (test (< ?l ?steps))
    =>
    (assert (robot (- ?x 1) ?y level (+ ?l 1) boxes $?boxes stores $?stores))
    (bind ?*nod-gen* (+ ?*nod-gen* 1))
)

(defrule move_right
    (robot ?x ?y level ?l boxes $?boxes stores $?stores)
    (max_steps ?steps)
    (map ?mx ?my)

    (test (< ?x ?mx)) ;; Check no right limit
    (not  (obs =(+ ?x 1) ?y)) ;; Check no obs right
    (test (not (member$ (create$ b (+ ?x 1) ?y) $?boxes))) ;; Check no box right
    (test (not (member$ (create$ s (+ ?x 1) ?y) $?stores))) ;; Check no store right
    (test (< ?l ?steps))
    =>
    (assert (robot (+ ?x 1) ?y level (+ ?l 1) boxes $?boxes stores $?stores))
    (bind ?*nod-gen* (+ ?*nod-gen* 1))
)

(defrule move_down
    (robot ?x ?y level ?l boxes $?boxes stores $?stores)
    (map ?mx ?my)
    (max_steps ?steps)

    (test (< ?y ?my)) ;; Not move down limit
    (not  (obs ?x =(+ ?y 1))) ;; Check no obs on bottom
    (test (not (member$ (create$ b ?x (+ ?y 1)) $?boxes))) ;; Check no box bottom
    (test (not (member$ (create$ s ?x (+ ?y 1)) $?stores))) ;; Check no store bottom
    (test (< ?l ?steps))
    =>
    (assert (robot ?x (+ ?y 1) level (+ ?l 1) boxes $?boxes stores $?stores))
    (bind ?*nod-gen* (+ ?*nod-gen* 1))
)

(defrule push_up
    (robot ?x ?y level ?l boxes $?boxes stores $?stores)
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
    (bind $?boxes (replace-member$ $?boxes (create$ b ?x (- ?y 2)) (create$ b ?x (- ?y 1))))
    (assert (robot ?x (- ?y 1) level (+ ?l 1) boxes $?boxes stores $?stores))
    (bind ?*nod-gen* (+ ?*nod-gen* 1))
)

(defrule push_down
    (robot ?x ?y level ?l boxes $?boxes stores $?stores)
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
    (bind $?boxes (replace-member$ $?boxes (create$ b ?x (+ ?y 2)) (create$ b ?x (+ ?y 1))))
    (assert (robot ?x (+ ?y 1) level (+ ?l 1) boxes $?boxes stores $?stores))
    (bind ?*nod-gen* (+ ?*nod-gen* 1))
)

(defrule push_left
    (robot ?x ?y level ?l boxes $?boxes stores $?stores)
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
    (bind $?boxes (replace-member$ $?boxes (create$ b (- ?x 2) ?y) (create$ b (- ?x 1) ?y)))
    (assert (robot (- ?x 1) ?y level (+ ?l 1) boxes $?boxes stores $?stores))
    (bind ?*nod-gen* (+ ?*nod-gen* 1))
)

(defrule push_right
    (robot ?x ?y level ?l boxes $?boxes stores $?stores)
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
    (bind $?boxes (replace-member$ $?boxes (create$ b (+ ?x 2) ?y) (create$ b (+ ?x 1) ?y)))
    (assert (robot (+ ?x 1) ?y level (+ ?l 1) boxes $?boxes stores $?stores))
    (bind ?*nod-gen* (+ ?*nod-gen* 1))
)

(defrule place_up
    (robot ?x ?y level ?l boxes $?boxes stores $?stores)
    (map ?mx ?my)
    (max_steps ?steps)

    (test (member$ (create$ b ?x (- ?y 1) ) $?boxes))
    (test (member$ (create$ s ?x (- ?y 2) 0) $?stores))
    (test (< ?l ?steps))
    =>
    (bind $?boxes (delete-member$ $?boxes (create$ b ?x (- ?y 1) )))
    (bind $?stores (replace-member$ $?stores (create$ s ?x (- ?y 2) 1) (create$ s ?x (- ?y 2) 0)))
    (assert (robot ?x (- ?y 1) level (+ ?l 1) boxes $?boxes stores $?stores))
    (bind ?*nod-gen* (+ ?*nod-gen* 1))
)

(defrule place_down
    (robot ?x ?y level ?l boxes $?boxes stores $?stores)
    (map ?mx ?my)
    (max_steps ?steps)

    (test (member$ (create$ b ?x (+ ?y 1) ) $?boxes))
    (test (member$ (create$ s ?x (+ ?y 2) 0) $?stores))
    (test (< ?l ?steps))
    =>
    (bind $?boxes (delete-member$ $?boxes (create$ b ?x (+ ?y 1) )))
    (bind $?stores (replace-member$ $?stores (create$ s ?x (+ ?y 2) 1) (create$ s ?x (+ ?y 2) 0)))
    (assert (robot ?x (+ ?y 1) level (+ ?l 1) boxes $?boxes stores $?stores))
    (bind ?*nod-gen* (+ ?*nod-gen* 1))
)

(defrule place_left
    (robot ?x ?y level ?l boxes $?boxes stores $?stores)
    (map ?mx ?my)
    (max_steps ?steps)

    (test (member$ (create$ b (- ?x 1) ?y ) $?boxes))
    (test (member$ (create$ s (- ?x 2) ?y 0) $?stores))
    (test (< ?l ?steps))
    =>
    (bind $?boxes (delete-member$ $?boxes (create$ b (- ?x 1) ?y) ))
    (bind $?stores (replace-member$ $?stores (create$ s (- ?x 2) ?y 1) (create$ s (- ?x 2) ?y 0)))
    (assert (robot (- ?x 1) ?y level (+ ?l 1) boxes $?boxes stores $?stores))
    (bind ?*nod-gen* (+ ?*nod-gen* 1))
)

(defrule place_right
    (robot ?x ?y level ?l boxes $?boxes stores $?stores)
    (map ?mx ?my)
    (max_steps ?steps)

    (test (member$ (create$ b (+ ?x 1) ?y ) $?boxes))
    (test (member$ (create$ s (+ ?x 2) ?y 0) $?stores))
    (test (< ?l ?steps))
    =>
    (bind $?boxes (delete-member$ $?boxes (create$ b (+ ?x 1) ?y) ))
    (bind $?stores (replace-member$ $?stores (create$ s (+ ?x 2) ?y 1) (create$ s (+ ?x 2) ?y 0)))
    (assert (robot (+ ?x 1) ?y level (+ ?l 1) boxes $?boxes stores $?stores))
    (bind ?*nod-gen* (+ ?*nod-gen* 1))
)

(defrule win
    (declare (salience 100))
    (robot ?x ?y level ?l boxes $?boxes stores $?stores)
    (test (= (length $?boxes) 0))
    =>
    (printout t "Found solution at level: " ?l crlf)
    (printout t "NUMERO DE NODOS EXPANDIDOS O REGLAS DISPARADAS " ?*nod-gen* crlf)
    (halt)
)