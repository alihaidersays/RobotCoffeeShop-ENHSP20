(define (domain airo2-group-H)
	(:requirements :adl :typing :fluents)

	(:types 
		place order waiter - object
		Bar Table - place
		Drink - order
	)

	(:predicates 
		(waiter-at ?w - waiter ?t - place)
		(start-moving-to ?w - waiter ?to - place)
		
        	(tray-taken)
		(tray-empty)
		
		(carrying-3-drinks ?w - waiter)
		(carrying-2-drinks ?w - waiter)
		(carrying-1-drink ?w - waiter)
        	(hand-free ?w - waiter)
		
        	(ordered ?d - Drink ?t - place)
		
		(barista-free)
		(waiter-free ?w - waiter)
		
		(start-order-preparing ?d - Drink)
		(order-prepared ?d - Drink)
		(order-ready ?d - order)
		(order-carried ?d - order ?w - waiter)
		(order-delivered ?d - order)
		
        	(clean ?t - place)
		(start-cleaning ?w - waiter ?t - place)

		(same-order ?d1 - order ?d2 - order)

		(serving ?w - waiter ?t - place)
		(served ?t - place)
		(place-free ?t - place)
	)

	(:functions 
		(distance ?t1 - place ?t2 - place)
		(fluent-table-size ?t - place)
		(fluent-hot ?d - Drink)
		(fluent-len-customer ?t - place)
		(fluent-len-tray ?w - waiter)
		(fluent-len-order)
		(fluent-len-clean ?w - waiter)
	)

	; --------- Preparation of Order ---------

	(:action 	action-start-order
	:parameters 	(?d - Drink)
	:precondition 	
		(and 
			(barista-free)
			(not (order-prepared ?d)) 
			(not (start-order-preparing ?d))
		)
	:effect
        	(and
			(not (barista-free))
			(start-order-preparing ?d)
			(assign (fluent-len-order) 0)
		)
	)

	(:process 	process-prepare-order
	:parameters	(?d - Drink)
	:precondition	(start-order-preparing ?d)
	:effect	(increase (fluent-len-order) #t)
	)

	(:event 	event-end-order
	:parameters	(?d - Drink)
	:precondition	
		(and
			(start-order-preparing ?d)
			(>= (fluent-len-order) (+ 3 (* 2 (fluent-hot ?d))))
		)
	:effect
		(and
			(not (start-order-preparing ?d))
			(order-prepared ?d)
			(order-ready ?d)
			(barista-free)
		)
	)

	; --------- Serving the Order ---------

	(:action 	serve-table    
	:parameters  	(?w - waiter ?t - Table )
	:precondition
	      	(and
			(not (served ?t))
		)
        :effect
        	(and  
			(served ?t)
			(serving ?w ?t)
		)
	)
	
	; --------- Order Delivery ---------
	
	(:action 	pick-up-order    
        :parameters  	(?t - Bar ?w - waiter ?d - order)
        :precondition
        	(and
			(= (fluent-len-tray ?w) 0)
			(waiter-at ?w ?t)
			(order-ready ?d)
			(hand-free ?w)
		)
        :effect
 		(and
			(not(order-ready ?d))
			(not(hand-free ?w))
			(order-carried ?d ?w)
		)
	)
	
	(:action 	put-down-order    
	:parameters  	(?t - Table ?w - waiter ?d - order)
	:precondition
        	(and
			(ordered ?d ?t)
			(= (fluent-len-tray ?w) 0)
			(waiter-at ?w ?t)
			(order-carried ?d ?w)
			(serving ?w ?t)
		)
	:effect
	      	(and
			(not (order-carried ?d ?w))
			(order-delivered ?d)
			(hand-free ?w)
		)
	)

	; --------- Waiter Move ---------

	(:action 	action-start-move   
        :parameters 	(?from - place ?to - place ?w - waiter)
        :precondition
        	(and 
			(waiter-free ?w)
			(waiter-at ?w ?from) 
		)
        :effect 
        	(and
			(place-free ?from)
			(not (waiter-free ?w))
			(not(waiter-at ?w ?from)) 
			(start-moving-to ?w ?to)
			(assign (fl-dist-from-goal ?w) (distance ?from ?to))
		)
	)
	
	(:process 	process-moving
	:parameters	(?w - waiter ?to - place)
	:precondition	(start-moving-to ?w ?to)
	:effect   	(decrease (fl-dist-from-goal ?w) (* (- 2 (fluent-len-tray ?w)) #t))
	)
	
	(:event 	event-end-move
	:parameters 	(?w - waiter ?to - place)
	:precondition
		(and
			(place-free ?to)
			(start-moving-to ?w ?to)
			(<= (fl-dist-from-goal ?w) 0)
		)
	:effect	
		(and
			(not (place-free ?to))
			(not (start-moving-to ?w ?to))
			(waiter-at ?w ?to)
			(waiter-free ?w)
		)
	)

	; --------- Clean Table ---------

	(:action 	action-clean-table-start   
        :parameters	(?t - place ?w - waiter)
        :precondition	
        	(and
			(waiter-free ?w)
			(not (clean ?t))
			(waiter-at ?w ?t) (hand-free ?w)
		)
        :effect 	
        	(and
			(start-cleaning ?w ?t)
			(assign (fluent-len-clean ?w) (* 2 (fluent-table-size ?t)))
			(not (waiter-free ?w))
		)
	)

	(:process 	process-cleaning-table
	:parameters	(?t - place ?w - waiter)
	:precondition	(start-cleaning ?w ?t)
	:effect	(decrease (fluent-len-clean ?w) #t)
	)

	(:event 	event-clean-table-end
	:parameters	(?t - place ?w - waiter)
	:precondition	
		(and
			(start-cleaning ?w ?t)
			(<= (fluent-len-clean ?w) 0)
		)
	:effect
		(and
			(not (start-cleaning ?w ?t))
			(clean ?t)
			(waiter-free ?w)
		)
	)

	; --------- Carrying Tray ---------

	(:action 	pick-2-tray
        :parameters	(?t - Bar ?w - waiter ?d1 - order ?d2 - order)
        :precondition
        	(and 
			(waiter-at ?w ?t)
			(not (same-order ?d1 ?d2))
			(hand-free ?w)(not (tray-taken))(tray-empty)
			(order-ready ?d1)(order-ready ?d2)
		)
        :effect
        	(and  
        		(not(order-ready ?d1))(not(order-ready ?d2))
			(not (hand-free ?w))(tray-taken)(not (tray-empty))
			(assign (fluent-len-tray ?w) 1)
			(order-carried ?d1 ?w) (order-carried ?d2 ?w)
			(carrying-2-drinks ?w)
		)
	)

	(:action 	pick-3-tray   
        :parameters	(?t - Bar ?w - waiter ?d3 - order)
        :precondition	
        	(and 
			(carrying-2-drinks ?w)
			(waiter-at ?w ?t)
			(order-ready ?d3)
		)
        :effect 
        	(and  
        		(not(order-ready ?d3))
			(order-carried ?d3 ?w)
			(not (carrying-2-drinks ?w)) (carrying-3-drinks ?w)
		)
	)

	; --------- Putting Down Drinks ---------

	(:action 	put-down-3-drink
        :parameters	(?t - Table ?w - waiter ?d3 - order)
        :precondition	
        	(and 
        		(carrying-3-drinks ?w)(waiter-at ?w ?t)
			(serving ?w ?t)
			(ordered ?d3 ?t)
			(order-carried ?d3 ?w)
		)
        :effect 
        	(and  
        		(not (order-carried ?d3 ?w))
			(order-delivered ?d3)
			(not (carrying-3-drinks ?w)) (carrying-2-drinks ?w)
		)
	)

	(:action 	put-down-2-drink   
        :parameters	(?t - Table ?w - waiter ?d2 - order)
        :precondition	
        	(and 
        		(carrying-2-drinks ?w)(waiter-at ?w ?t)
			(serving ?w ?t)
			(ordered ?d2 ?t)
			(order-carried ?d2 ?w)
		)
        :effect
        	(and 
        		(not (order-carried ?d2 ?w))
			(order-delivered ?d2)
			(not (carrying-2-drinks ?w)) (carrying-1-drink ?w)
		)
	)

	(:action 	put-down-1-drink   
        :parameters	(?t - Table ?w - waiter ?d1 - order)
        :precondition	
        	(and 
        		(carrying-1-drink ?w)(waiter-at ?w ?t)
			(serving ?w ?t)
			(ordered ?d1 ?t)
			(order-carried ?d1 ?w)
		)
        :effect 
        	(and  
        		(not (order-carried ?d1 ?w))
			(order-delivered ?d1)
			(not (carrying-1-drink ?w))
			(tray-empty)
		)
	)

	; --------- Putting Down Tray ---------

	(:action 	drop-tray   
        :parameters	(?t - Bar ?w - waiter)
        :precondition
        	(and
			(= (fluent-len-tray ?w) 1)
			(tray-empty)(waiter-at ?w ?t)
		)
        :effect 
        	(and
			(assign (fluent-len-tray ?w) 0)
			(not (tray-taken))
			(hand-free ?w)
		)
	)
)
