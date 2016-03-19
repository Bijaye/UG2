% ---------------------------------------------------------------------
%  ----- Informatics 2D - 2015/16 - Second Assignment - Planning -----
% ---------------------------------------------------------------------
%
% Write here you matriculation number (only - your name is not needed)
% Matriculation Number: s_______
%
%
% ------------------------- Problem Instance --------------------------
% This file is a template for a problem instance: the definition of an
% initial state and of a goal.

% debug(on).	% need additional debug information at runtime?



% --- Load domain definitions from an external file -------------------

:- ['domain-task33.pl'].		% Replace with the domain for this problem


% --- Definition of the initial state ---------------------------------


agent(agent).
connected(d,pl).
connected(pl,d).
connected(pl,p).
connected(p,pl).

at(agent,d,s0).
spaces(2,s0).


car(carA).
key(keyA,carA).
at(carA,d,s0).
at(keyA,d,s0).


car(carB).
key(keyB,carB).
at(carB,d,s0).
at(keyB,d,s0).

% There is no need to model the other parked cars in the parking lot,
% as there are 2 empty spaces and thus carA and carB, regardless of what happens to the other 2 cars.



% --- Goal condition that the planner will try to reach ---------------

%goal(S) :- stored(keyA,S),stored(keyB,S).		% fill in the goal definition

goal(S) :- stored(keyA,S),stored(keyB,S).


% ---------------------------------------------------------------------
% ---------------------------------------------------------------------
