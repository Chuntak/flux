%===========================================================%
% Main Loop            										%
%  Explaination is done in the powerpoint and in the report %
%===========================================================%

main:-
	init(Z0),
	execute(clean, Z0, Z1),
	main_loop([[0,1,2,3]], [], Z1).
	

main_loop([Choices|Choicepoints], Backtrack, Z):-
	Choices = [Direction|Directions] ->
	( go_in_direction(Direction, Z, Z1)
		-> execute(clean, Z1, Z2),
			Choicepoints1 = [[0,1,2,3], Directions | Choicepoints],
			Backtrack1 = [Direction | Backtrack],
			main_loop(Choicepoints1, Backtrack1, Z2)
		;
		main_loop([Directions|Choicepoints], Backtrack, Z) )
	;
	backtrack(Choicepoints, Backtrack, Z).
	
go_in_direction(D, Z1, Z2):-
	knows_val([X,Y], at(X,Y), Z1),
	adjacent(X, Y, D, X1, Y1),
	\+ knows(cleaned(X1, Y1), Z1),
	knows_not(occupied(X1, Y1), Z1),
	turn_to_go(D, Z1, Z2).
	
backtrack(_, [], _).
backtrack(Choicepoints, [Direction|Backtrack], Z):-
	Reverse is ((Direction+2) mod 4),
	turn_to_go(Reverse, Z, Z1),
	main_loop(Choicepoints, Backtrack, Z1).
	
turn_to_go(D, Z1, Z2):-
	knows(facing(D), Z1) -> execute(go, Z1, Z2)
	;
	execute(turn, Z1, Z), turn_to_go(D,Z,Z2).



adjacent(X, Y, D, X1, Y1):-
	D is 0,
	X1 is X + 1,
	Y1 is Y,
	isNotOutOfBound(X1, Y1).
adjacent(X, Y, D, X1, Y1):-
	D is 1,
	X1 is X,
	Y1 is Y + 1,
	isNotOutOfBound(X1, Y1).
adjacent(X, Y, D, X1, Y1):-
	D is 2,
	X1 is X - 1,
	Y1 is Y,
	isNotOutOfBound(X1, Y1).
adjacent(X, Y, D, X1, Y1):-
	D is 3,
	X1 is X,
	Y1 is Y - 1,
	isNotOutOfBound(X1, Y1).