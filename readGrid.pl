%===========================================================%
% Input Reading Info										%
%	robot(X,Y)												%
%	  Adds the initialized robot at X,Y                     %
% 	grid(X,Y)												%
%	  Sets the boundary										%
%	person(X,Y)												%
%	  Takes in the position of the person and create a		%
%	  light(X,Y,I) fact for the robot to sense				%
%	assertLight(X,Y)										%
%	  Assert the light(X,Y,I) fact into the database		%
%	  The I represents the intensity, this will help		%
%	  a corner case (Explained more in the document)		% 
%===========================================================%
robot(X,Y):-
	\+ factExists(init, 1),
	assert(init([at(X,Y), facing(1)])).

% There can only be 1
robot(X,Y):-
	factExists(init, 1),
	init(Remove),
	retract(init(Remove)),
	assert(init([at(X,Y), facing(1)])).

% There can only be 1
grid(X,Y):-
	number(X),
	number(Y),
	!,
	factExists(bound, 2) -> (
		bound(X1,Y1),
		retract(bound(X1,Y1)),
		assert(bound(X,Y))
	);
	assert(bound(X,Y)).

	
person(X,Y):-
	factExists(p,2),
	p(X,Y).

person(X,Y):-
	factExists(p,2),
	\+ p(X,Y),
	X1 is X + 1, 
	Y1 is Y + 1,
	X0 is X - 1,
	Y0 is Y - 1,
	assertLight(X1,Y),
	assertLight(X, Y1),
	assertLight(X0, Y),
	assertLight(X, Y0),
	assert(p(X,Y)).
	
person(X,Y):-
	\+ factExists(p,2),
	X1 is X + 1, 
	Y1 is Y + 1,
	X0 is X - 1,
	Y0 is Y - 1,
	assertLight(X1,Y),
	assertLight(X, Y1),
	assertLight(X0, Y),
	assertLight(X, Y0),
	assert(p(X,Y)).


assertLight(X,Y):-
	\+ isNotOutOfBound(X,Y).

assertLight(X,Y):-
	factExists(light, 3),
	isNotOutOfBound(X,Y),
	light(X,Y,Z),
	retract(light(X,Y,Z)),
	Z1 is Z + 1,
	assert(light(X,Y,Z1)).
	
assertLight(X,Y):-
	factExists(light, 3),
	isNotOutOfBound(X,Y),
	\+ light(X,Y,_),
	assert(light(X,Y,1)).
	
assertLight(X,Y):-
	\+ factExists(light, 3),
	isNotOutOfBound(X,Y),
	assert(light(X,Y,1)).

% THIS IS A HACK TO PREVENT LIGHT CALL NOT FOUND IF NO PERSON IS ADDED IN %
light(-1,-1,-1).