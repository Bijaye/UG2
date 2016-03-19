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

:- multifile at/3, parked/2, delivered/2, connected/2, car/1, agent/1, dirty/2.



% --- Primitive control actions ---------------------------------------
% this section defines the name and the number of parameters of the
% actions available to the planner
%
% primitive_action( dosomething(_,_) ).	% underscore means `anything'

primitive_action( move(_,_) ).
primitive_action( park(_) ).
primitive_action( drive(_,_,_) ).
primitive_action( deliver(_) ).
primitive_action( clean(_) ).



% --- Precondition for primitive actions ------------------------------
% describe when an action can be carried out, in a generic situation S
%
% poss( doSomething(...), S ) :- preconditions(..., S).


poss( move(From, To), S ) :-
  at(agent, From, S),
  connected(From,To).

poss( park(C), S ) :-
  car(C),
  at(agent,pl,S),
  at(C,pl,S).

poss( drive(C,From,To), S ) :-
  car(C),
  at(agent,From,S),
  at(C,From,S),
  connected(From,To).

% Add not(dirty)
poss( deliver(C), S ) :-
  car(C),
  not(dirty(C,S)),
  at(agent,p,S),
  at(C,p,S).

% Impose that the car is cleand while in the parking lot, so that "the agent must clean the parked car
% before driving it to the pick-up area" i.e. it can't be cleaned in the drop offs
poss( clean(C), S) :-
  car(C),
  at(agent,pl,S),
  at(C,pl,S).

% --- Successor state axioms ------------------------------------------
% describe the value of fluent based on the previous situation and the
% action chosen for the plan.
%
% fluent(..., result(A,S)) :- positive; previous-state, not(negative)



at(X,L,result(A,S)) :-
  ( agent(X),
    ( A=move(_,L);
      A=drive(_,_,L);
      at(X,L,S), not(A=move(L,_)), not(A=drive(_,L,_))
    )

  );
  ( car(X),
    ( A=drive(X,_,L);
      at(X,L,S), not(A=drive(X,L,_)), not(A=deliver(X))
    )

  ).

dirty(X,result(A,S)) :-
  A=park(X);
  dirty(X,S), not(A=clean(X)).

parked(C,result(A,S)) :-
  A=park(C);
  parked(C,S), not(A=drive(C,_,_)).

delivered(C,result(A,S) ) :-
  A=deliver(C);
  delivered(C,S).




% ---------------------------------------------------------------------
% ---------------------------------------------------------------------
