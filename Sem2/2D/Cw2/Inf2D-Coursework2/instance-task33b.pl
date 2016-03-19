% ---------------------------------------------------------------------
%  ----- Informatics 2D - 2015/16 - Second Assignment - Planning -----
% ---------------------------------------------------------------------
%
% Write here you matriculation number (only - your name is not needed)
% Matriculation Number: s1427590
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
spaces(0,s0).

% carB is aleady parked and dirty
car(carB).
key(keyB,carB).
at(carB,pl,s0).
parked(carB,s0).
stored(keyB,s0).
dirty(carB,s0).

% new customet drops off carA
car(carA).
key(keyA,carA).
at(carA,d,s0).
at(keyA,d,s0).



% There is no need to model the other parked cars in the parking lot,
% as after delivering carB there will be one free space for carA
% Including the other 3 parked cars carC, carD and carE increases the search space and thus the time for finding a solution,
% but the same 10 steps are returned.

% --- Goal condition that the planner will try to reach ---------------

goal(S) :- delivered(carB,S),parked(carA,S).			% fill in the goal definition




% ---------------------------------------------------------------------
% ---------------------------------------------------------------------
