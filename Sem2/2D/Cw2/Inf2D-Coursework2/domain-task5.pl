% ---------------------------------------------------------------------
%  ----- Informatics 2D - 2015/16 - Second Assignment - Planning -----
% ---------------------------------------------------------------------
%
% Write here you matriculation number (only - your name is not needed)
% Matriculation Number: s1427590
%
%
% ------------------------- Domain Definition -------------------------
% This file describes a planning domain: a set of predicates and
% fluents that describe the state of the system, a set of actions and
% the axioms related to them. More than one problem can use the same
% domain definition, and therefore include this file


% --- Cross-file definitions ------------------------------------------
% marks the predicates whose definition is spread across two or more
% files
%
% :- multifile name/#, name/#, name/#, ...

:- multifile at/3, agentAt/2, parked/2, delivered/2, connected/2, car/1, agent/1.



% --- Primitive control actions ---------------------------------------
% this section defines the name and the number of parameters of the
% actions available to the planner
%
% primitive_action( dosomething(_,_) ).	% underscore means `anything'

primitive_action( move(_,_) ).
primitive_action( park(_) ).
primitive_action( drive(_,_,_) ).
primitive_action( deliver(_) ).




% --- Precondition for primitive actions ------------------------------
% describe when an action can be carried out, in a generic situation S
%
% poss( doSomething(...), S ) :- preconditions(..., S).

% Agent(a) and At(a,from,s) and Connected(from,to) => Poss(Move(a,x,y),s)
poss( move(From, To), S ) :-
  agentAt(From, S),
  connected(From,To).

% Car(c) and At(Agent,Pl,s) and At(c,Pl,s) and not Parked(c,s) => Poss(Park(c),s)
poss( park(C), S ) :-
  car(C),
  agentAt(pl,S),
  at(C,pl,S),
  not(parked(C,S)).

% Car(c) and At(Agent,from,s) and At(c,from,s) and Connected(from,to) => Poss(Drive(c,from,to),s)
poss( drive(C,From,To), S ) :-
  car(C),
  agentAt(From,S),
  at(C,From,S),
  connected(From,To).

% Precond: Car(c) and At(Agent,P,s) and At(c,P,s) and not(Delivered(c,s)) => Poss(Deliver(c),s)
poss( deliver(C), S ) :-
  car(C),
  agentAt(p,S),
  at(C,p,S).



% --- Successor state axioms ------------------------------------------
% describe the value of fluent based on the previous situation and the
% action chosen for the plan.
%
% fluent(..., result(A,S)) :- positive; previous-state, not(negative)




%at( X, L, result(A,S) ) :-
%A=drive(X,_,L);
%at(X,L,S), not(A=drive(X,_,_)), not(A=deliver(X));

at(X, L, result(A,S) ) :-
  A=drive(X,_,L);
  at(X,L,S), not(A=drive(X,L,_)), not(A=deliver(X)).

agentAt(L,result(A,S)) :-
  A=move(_,L);
  A=drive(_,_,L);
  agentAt(L,S), not(A=move(L,_)), not(A=drive(_,L,_)).

parked(C,result(A,S)) :-
  A=park(C);
  parked(C,S), not(A=drive(C,pl,_)).

delivered(C,result(A,_) ) :-
  A=deliver(C).




% ---------------------------------------------------------------------
% ---------------------------------------------------------------------
