(define (problem airo2-group-H-problem-1)   
	(:domain airo2-group-H)
	(:objects 
		bar - Bar
		table1 table2 table3 table4 - Table 
        	drink-1 drink-2 - Drink
        	w - waiter 
	)

	(:init
		(hand-free w)
		(waiter-at w bar)
		(barista-free)
		(waiter-free w)
		(tray-empty)
		
		(= (fluent-len-tray w) 0)

		; --------- fluent-hot drink-1 = 0 for cold drink, 1 for hot drink ---------

		(= (fluent-hot drink-1) 0)
		(= (fluent-hot drink-2) 0)

		; --------- distances ---------

		(= (distance bar table1) 2) 		(= (distance table1 bar) 2)
		(= (distance bar table2) 2) 		(= (distance table2 bar) 2)
		(= (distance table1 table2) 1)		(= (distance table2 table1) 1)

		(= (distance bar table3) 3) 		(= (distance table3 bar) 3)
		(= (distance table1 table3) 1) 	(= (distance table3 table1) 1)
		(= (distance table3 table2) 1)		(= (distance table2 table3) 1)

		(= (distance bar table4) 3) 		(= (distance table4 bar) 3)
		(= (distance table1 table4) 1) 	(= (distance table4 table1) 1)
		(= (distance table4 table2) 1)		(= (distance table2 table4) 1)
		(= (distance table4 table3) 1)		(= (distance table3 table4) 1)

		; --------- Table sizes ---------

		(= (fluent-table-size table1) 1)
		(= (fluent-table-size table2) 1)
		(= (fluent-table-size table3) 2)
		(= (fluent-table-size table4) 1)

		; --------- Assignment of drinks for each table ---------

        	(ordered drink-1 table2)
        	(ordered drink-2 table2)

        	(=(fluent-len-customer table1) 0)
        	(=(fluent-len-customer table2) 2)
	        (=(fluent-len-customer table3) 0)
        	(=(fluent-len-customer table4) 0)

		(place-free table1)
		(place-free table2)
		(place-free table3)
		(place-free table4)

        	(same-order drink-1 drink-1)
        	(same-order drink-2 drink-2)
	)

	(:goal
		(and 
			(order-delivered drink-1)
			(order-delivered drink-2)
			(clean table3)
			(clean table4)
		)
	)
)
