%==============================================================%
% knows:                                                       %
%   Uses to extract data from the states                       %
%   Or to check if the robot knows if it has cleaned a space   %
% know_not:                                                    %
%   Check to make sure if the robot doesn't know a space is    %
%   occupied, if it knows or thinks that a space is occupied   %
%   it will not move to that space                             %
%==============================================================%
knows_val([X,Y], at(X,Y), [at(X,Y)|_]).
knows_val([X,Y], at(X,Y), [H|T]):-
	H \= at(X,Y),
	knows_val([X,Y], at(X,Y), T).	


knows(facing(Dir), [facing(Dir)|_]).
knows(facing(Dir), [H|T]):-
	H \= facing(Dir),
	knows(facing(Dir), T).

knows(cleaned(X,Y), [cleaned(X,Y)|_]).
knows(cleaned(X,Y), [H|T]):-
	H \= cleaned(X,Y),
	knows(cleaned(X,Y), T).

knows_not(Occupied, [or_holds(L)|Z]):-
	\+ contains(L, Occupied),
	!,
	knows_not(Occupied, Z).

knows_not(Occupied, [knows(Occupied)|_]):-
	fail.

knows_not(Occupied, [X|Z]):-
	X \= knows(_),
	X \= or_holds(_),
	knows_not(Occupied, Z).

knows_not(Occupied, [knows(Occupied2)|Z]):-
	Occupied \= Occupied2,
	knows_not(Occupied, Z).

knows_not(_, []).