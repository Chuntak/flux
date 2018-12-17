%===========================================================%
% Support Methods   										%
%	isNotOutOfBound(X,Y)									%
%	  Makes sure the coordinates given in is not out        % 
%     of bound                                              %
% 	factExists(Name, Arity)                                 %
%	  Makes sure there is atleast 1 predicate of -Name-		%
%     in the database                                       %
%	append(L, L2, L3)										%
%	  Appends L and L2 into L3                      		%
%	contains(L,X)      										%
%	  Check if X is in the list L                   		%
%   printStates(L)                                          %
%     Prints the states in the list                         %
%   removeSingleList(L, X)                                  %
%     Takes out the single element of the list              %
%===========================================================%

isNotOutOfBound(X,Y):-
	factExists(grid, 2),
	bound(Row, Col),
	X > -1,
	Y > -1,
	X < Row,
	Y < Col.	
	
factExists(Name, Arity):-
	functor(X, Name, Arity),
	predicate_property(X, visible).

append([H|X], Y, [H|Z]):-
	append(X, Y, Z).
append([], Y,Y).

contains([_|T], X):-
	contains(T,X).	
contains([H|_], H).


printStates([H|Z]):-
	write(H),
	printStates(Z).
printStates([]):-
	nl.

removeSingleList([H], H).
