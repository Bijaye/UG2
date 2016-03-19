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
at(carA,d,s0).
at(keyA,d,s0).






% --- Goal condition that the planner will try to reach ---------------

goal(S) :- at(carA,pl,S), stored(keyA,S).			% fill in the goal definition





% ---------------------------------------------------------------------
% ---------------------------------------------------------------------
