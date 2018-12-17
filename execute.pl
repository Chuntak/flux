%===========================================================%
% execute													%
%	clean: adds a fluent that the robot has clean at 		%
%		   the position its in								%
%   go:    move the robot up one by the direction its       %
%          facing and uses flux to determine if a space     %
%          is occupied and update the states                %
%          everytime robot moves, it will print the states  %
%   turn:  turns the robot by 1 ie: North(0) to East(1)     %
%===========================================================%
execute(clean, [at(X,Y)|T], [cleaned(X,Y),at(X,Y)|T]):-
	atom_concat("Cleaned at position ", X, String),
	atom_concat(String, ",", String2),
	atom_concat(String2, Y, String3),
	writeln(String3).
	
execute(clean, [H|T], [H|Z1]):-
	H \= at(_,_),
	execute(clean, T, Z1).

execute(turn, [facing(Dir)|T], [facing(Dir1)|T]):-
	Dir1 is (Dir + 1) mod 4,
	atom_concat("Turning to ", Dir1, String),
	writeln(String).

execute(turn, [H|T], [H|Z1]):-
	H \= facing(_),
	execute(turn, T, Z1).

execute(go, Z0, Z2):-
	executeGo(go, Z0, Z1),
	explore(Z1, Z2),
    writeln(Z2).


executeGo(go, [at(X,Y)|T], [at(X1,Y)|T]):-
	knows(facing(Dir), T),
	Dir is 0,
	X1 is X + 1,
	atom_concat("Going in Direction ", Dir, String),
	writeln(String).

executeGo(go, [at(X,Y)|T], [at(X,Y1)|T]):-
	knows(facing(Dir), T),
	Dir is 1,
	Y1 is Y + 1,
	atom_concat("Going in Direction ", Dir, String),
	writeln(String).

executeGo(go, [at(X,Y)|T], [at(X0,Y)|T]):-
	knows(facing(Dir), T),
	Dir is 2,
	X0 is X - 1,
	atom_concat("Going in Direction ", Dir, String),
	writeln(String).

executeGo(go, [at(X,Y)|T], [at(X,Y0)|T]):-
	knows(facing(Dir), T),
	Dir is 3,
	Y0 is Y - 1,
	atom_concat("Going in Direction ", Dir, String),
	writeln(String).

executeGo(go, [H|T], [H|Z1]):-
	H \= at(_,_),
	executeGo(go, T, Z1).

%===========================================================%
% explore:                                                  %
%   Senses if there is a light or not and applies logic     %
%   accordingly to add or eliminate the possiblity of an    %
%   occupied space                                          %
%===========================================================%

explore(Z0, Z1):-
	knows_val([X,Y], at(X,Y), Z0),
	\+ light(X,Y,_),
	sensedNoLight(X,Y,Z0,Z1).

explore(Z0, Z1):-
	knows_val([X,Y], at(X,Y), Z0),
	light(X,Y,I),
	sensedLight(X,Y,I,Z0,NewKnowledge),
	append(NewKnowledge, Z0, Z1).


sensedNoLight(X,Y,[or_holds(Fluent)|T],[H|T]):-
	reductionLightLogic(X,Y,Fluent,Reduced),
	length(Reduced, 1),
	!,
	removeSingleList(Reduced, Fact),
	H = knows(Fact).

sensedNoLight(X,Y,[or_holds(Fluent)|T],T):-
	reductionLightLogic(X,Y,Fluent,Reduced),
	length(Reduced, 0),
	!.

sensedNoLight(X,Y,[or_holds(Fluent)|T],[H|T]):-
	reductionLightLogic(X,Y,Fluent,Reduced),
	\+ length(Reduced, 0),
	!,
	H = or_holds(Reduced).

sensedNoLight(X,Y,[H|T], [H|T]):-
	H \= or_holds(_),
	sensedNoLight(X,Y,T,T).
sensedNoLight(_,_,[],[]).


sensedLight(X,Y,I,Z,[H|NewKnowledge]):-
	I \= 0,
	findall(Occupied, lightToOccupied(X,Y,Z,Occupied), OccupiedList),
	H = or_holds(OccupiedList),
	I0 is I - 1,
	sensedLight(X,Y,I0,Z,NewKnowledge).

sensedLight(_,_,0,_,[]).


reductionLightLogic(X,Y,[occupied(X1,Y1)|T],Reduced):-
	withinRange(X,Y,X1,Y1),
	!,
	reductionLightLogic(X,Y,T,Reduced).

reductionLightLogic(X,Y,[occupied(X1,Y1)|T], [occupied(X1,Y1)|Reduced]):-
	\+ withinRange(X,Y,X1,Y1),
	!,
	reductionLightLogic(X,Y,T,Reduced).

reductionLightLogic(X,Y,[H|T], [H|Reduced]):-
	H \= occupied(_,_),
	!,
	reductionLightLogic(X,Y,T,Reduced).

reductionLightLogic(_, _, [], []).


withinRange(X,Y,X1,Y):-
	X1 is X + 1.
withinRange(X,Y,X,Y1):-
	Y1 is Y + 1.
withinRange(X,Y,X0,Y):-
	X0 is X - 1.
withinRange(X,Y,X,Y0):-
	Y0 is Y - 1.


lightToOccupied(X,Y,Z,occupied(X1,Y)):-
	X1 is X+1,
	isNotOutOfBound(X1,Y),
	notAlreadyExplored(X1,Y,Z).

lightToOccupied(X,Y,Z,occupied(X,Y1)):-
	Y1 is Y+1,
	isNotOutOfBound(X,Y1),
	notAlreadyExplored(X,Y1,Z).
	
lightToOccupied(X,Y,Z,occupied(X0,Y)):-
	X0 is X-1,
	isNotOutOfBound(X0,Y),
	notAlreadyExplored(X0,Y,Z).
	
lightToOccupied(X,Y,Z,occupied(X,Y0)):-
	Y0 is Y-1,
	isNotOutOfBound(X,Y0),
	notAlreadyExplored(X,Y0,Z).


notAlreadyExplored(X,Y, [H|T]):-
	H \= cleaned(_,_),
	notAlreadyExplored(X,Y,T).

notAlreadyExplored(X,Y, [cleaned(X,Y)|_]):-
	fail.

notAlreadyExplored(X,Y, [cleaned(X1,Y1)|T]):-
	X \= X1,
	Y \= Y1,
	notAlreadyExplored(X,Y,T).

notAlreadyExplored(X,Y, [cleaned(X1,Y1)|T]):-
	X == X1,
	Y \= Y1,
	notAlreadyExplored(X,Y,T).

notAlreadyExplored(X,Y, [cleaned(X1,Y1)|T]):-
	X \= X1,
	Y == Y1,
	notAlreadyExplored(X,Y,T).

notAlreadyExplored(_,_,[]).
