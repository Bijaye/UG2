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

:- ['domain-task32.pl'].		% Replace with the domain for this problem


% --- Definition of the initial state ---------------------------------


agent(agent).
connected(d,pl).
connected(pl,d).
connected(pl,p).
connected(p,pl).

at(agent,d,s0).

car(carA).
key(keyA,carA).
at(carA,pl,s0).
parked(carA,s0).
dirty(carA,s0).
stored(keyA,s0).

car(carB).
at(carB,d,s0).
key(keyB,carB).
holding(keyB,s0).








% --- Goal condition that the planner will try to reach ---------------

goal(S) :- stored(keyB,S), delivered(carA,S).			% fill in the goal definition




% ---------------------------------------------------------------------
% ---------------------------------------------------------------------
