-- Inf2D Assignment 1 (Last updated: 25 Jan 2016)

-- Good Scholarly Practice
-- Please remember the University requirement as regards all assessed work for credit.
-- Details about this can be found at:
-- http://www.ed.ac.uk/academic-services/students/undergraduate/discipline/academic-misconduct
-- and at:
-- http://web.inf.ed.ac.uk/infweb/admin/policies/academic-misconduct
-- Furthermore, you are required to take reasonable measures to protect your assessed work from
-- unauthorised access.For example, if you put any such work on a public repository then you must
-- set access permissions appropriately (generally permitting access only to yourself, or your
-- group in the case of group practicals).

module Inf2d where
import Data.List
import Debug.Trace
import Data.Ord
import Data.Maybe
import Control.Exception
import Data.Time
-- Type synonyms for the data structures
-- Symbols are strings (a negative sign as the first character represents a negated symbol)
type Symbol = String
-- Clause = a disjuntion of symbols
type Clause = [Symbol]
-- Sentence = Statements. This is a list of a list of symbols
type Sentence = [[Symbol]]
-- Models are represented as a list of (Symbol,Boolean) tuples
type Model = [(Symbol, Bool)]
-- The knowledge base is represented as a list of statements
type KB = [Sentence]


-----------------------------------------------
-- STUDENT MATRICULATION NUMBER:
-----------------------------------------------
studentId::String
studentId = "s1427590"

--------------------------------------------------
-- ASSIGNMENT TASKS
-- Refer to assignment sheet for details of tasks
--------------------------------------------------

----------TASK 1: REPRESENTATION (2 marks)----------------------------------------------------------
wumpusFact::Sentence
wumpusFact = [["-B11","P11","P22","P31"],["B11","-P11"],["B11","-P22"],["B11","-P31"]]

----------TASK 2: GENERAL HELPER FUNCTIONS (10 marks)-----------------------------------------------

-- Finds the assigned literal to a symbol from a given model
lookupAssignment :: Symbol -> Model -> Maybe Bool
lookupAssignment symbol model
  | x == [] = Nothing
  | otherwise= Just (head(x))
    where x=[snd(tuple)|tuple<-model, fst(tuple)==symbol]


-- helper function, extend lookupAssignment to work for negated symbols
lookupAssignment2 :: Symbol -> Model -> Maybe Bool
lookupAssignment2 x model
  |isNegated x=let as=lookupAssignment (getUnsignedSymbol x) model
               in if as/=Nothing then Just(not(fromJust (as))) else Nothing
  |otherwise=lookupAssignment x model


-- Negate a symbol
negateSymbol :: Symbol -> Symbol
negateSymbol symbol
   | isNegated(symbol) = tail(symbol)
   | otherwise= "-"++symbol

-- For a given symbol, this function checks if it is negated(i.e., has a negation sign).
isNegated :: Symbol -> Bool
isNegated symbol = head(symbol)=='-'

-- This function takes a symbol and returns an Symbol without any negation sign if the original
-- symbol had one.
getUnsignedSymbol :: Symbol -> Symbol
getUnsignedSymbol symbol
   | isNegated(symbol)=negateSymbol(symbol)
   | otherwise=symbol

-- Gets a list of all symbols in all given sentences
getSymbols :: [Sentence] -> [Symbol]
getSymbols stmts = remDup(map getUnsignedSymbol (foldl (++) [] (foldl (++) [] stmts)) )  --concatenate symbols from sentences

-- Helper function to get a list without duplicates
remDup :: [String] -> [String]
remDup=map head. group. sort

----------TASK 3: TRUTH TABLE ENUMERATION AND ENTAILMENT (40 marks)---------------------------------

-- Function takes as input a list of symbols, and returns a list of models (all possible assignment
-- of True or False to the symbols.)
generateModels :: [Symbol] -> [Model]
generateModels []=[]
generateModels (x:[])=[[(x,True)],[(x,False)]]
generateModels (x:xs) =(map (\a->a++[(x,True)]) (rest))++(map (\a->a++[(x,False)]) (rest)) where rest=generateModels(xs)


-- This function evaluates the truth value of a propositional sentence using the symbols
-- assignments in the model.
-- Check if all the clauses are true
-- A symbol not in the model evaluates to False, so it works with partial assignments too
-- (evaluating to False is a way of disregarding those variables when we are looking for True values)
pLogicEvaluate :: Sentence -> Model -> Bool
pLogicEvaluate stmt model = foldl (&&) True (map  (foldl (||) False) values) where values=map (\a->disjunction a model) stmt

-- Helper function which returns a list of assignments for the given list of symbols. A symbol which is not in the model evaluates to False
-- (by doing this I avoided throwing an error.)
-- Also, this function can be later used to evaluate clauses with partial models.
disjunction :: Clause -> Model -> [Bool]
disjunction symbols model=[if isNegated x
                          then not(fromMaybe True (lookupAssignment (getUnsignedSymbol x) model))
                          else (fromMaybe False (lookupAssignment x model)) |x<-symbols]


-- This function checks the truth value of list of a propositional sentence using the symbols
-- assignments in the model. It returns true only when all sentences in the list are true.
plTrue :: [Sentence] -> Model -> Bool
plTrue sentences model =foldl (&&) True ([pLogicEvaluate x model|x<-sentences])

-- This function takes as input a knowledgebase (i.e. a list of propositional sentences),
-- a query (i.e. a propositional sentence), and a list of symbols.
-- It recursively enumerates the models of the domain using its symbols to check if there
-- is a model that satisfies the knowledge base and the query. It returns a list of all such models.

-- Check that "the query is satisfied by every model that satisfies the knowledge base".
-- So if there are some models that make the kb true but not the query, return the empty list.
-- This is done by checking for "Nothing" in the
-- output of the auxiliary function ttCheckAllAux (this means there is no entailment).
-- Also, disregard empty models, which means the KB is false.

ttCheckAll :: [Sentence] -> Sentence -> [Symbol] -> [Model]
ttCheckAll kb query symbols
  |elem Nothing ans=[]   --return the empty list if there is a case when the model satisfies the kb but not the query
  |otherwise=map (fromJust) (filter (\x->x/=Just []) ans)   --return the models if there is the case of entailment
 where ans=ttCheckAllAux kb query symbols []

-- Auxiliary function for ttCheckAll. It returns the list of models that satisfy the knowledge base and the query.
-- If a model does not satify the model, it does not matter so we just append [] to the answer
-- If a model satisfies the kb but not the query, we return a value of Nothing, so we know the entailment failed.
-- (this case is late is checked by ttCheckAll)
ttCheckAllAux :: [Sentence] -> Sentence -> [Symbol] -> Model -> [Maybe Model]
ttCheckAllAux kb query [] model
    | plTrue kb model= if pLogicEvaluate query model then [Just model] else [Nothing]  --returning Nothing means the entailment fails
    | otherwise=[Just []]  --this is equivalent to returing true, when the model does not satisfy the kb
ttCheckAllAux kb query symbols model=(ttCheckAllAux kb query rest ((p,True):model))++(ttCheckAllAux kb query rest ((p,False):model))
                         where p=head(symbols)
                               rest=tail(symbols)


-- This function determines if a model satisfes both the knowledge base and the query, returning
-- true or false.
-- If ttCheck returns any models, the knowledge entails the query.
ttEntails :: [Sentence] -> Sentence -> Bool
ttEntails kb query
  |ttCheck==[]=False
  |otherwise=True
  where symbols=remDup ((getSymbols kb)++(getSymbols [query]))      -- include symbols from the query
        ttCheck=ttCheckAll kb query symbols


-- This function determines if a model satisfes both the knowledge base and the query.
-- It returns a list of all models for which the knowledge base entails the query.
ttEntailsModels :: [Sentence] -> Sentence -> [Model]
ttEntailsModels kb query =  ttCheckAll kb query symbols
     where symbols=remDup ((getSymbols kb)++(getSymbols [query]))


----------TASK 4: DPLL (43 marks)-------------------------------------------------------------------

-- The early termination function checks if a sentence is true or false even with a
-- partially completed model.

-- returns true if the sentence can be evaluated in any way

earlyTerminate :: Sentence -> Model -> Bool
earlyTerminate sentence model
 | elem [] partials = False                                                        --return False if any of the clauses cannot be evaluated
 | otherwise=(foldl (&&) True (map (\x->elem (Just True) x) partials)) ||          --check all clauses evaluate to true
                                                                                   --or check if there is a clause that can be evaluated to False
                                                                                   --(there are no True or unassigned symbols)
             (foldl (||) False (map (\x->not(elem (Just True) x)&&not(elem Nothing x)) partials))
 where partials=getPartials sentence model

-- helper function to get a list of assignments for a sentence and a partial model
getPartials :: Sentence -> Model -> [[Maybe Bool]]
getPartials sentence model=[map (\x-> lookupAssignment2 x model) clause |clause <- sentence]

-- This function finds pure symbol, i.e, a symbol that always appears with the same "sign" in all
-- clauses.
-- It takes a list of symbols, a list of clauses and a model as inputs.
-- It returns Just a tuple of a symbol and the truth value to assign to that
-- symbol. If no pure symbol is found, it should return Nothing
findPureSymbol :: [Symbol] -> [Clause] -> Model -> Maybe (Symbol, Bool)
findPureSymbol [] clauses model = Nothing
findPureSymbol (s:sym) clauses model=if pure /= Nothing
                                     then Just (getUnsignedSymbol s,fromJust pure)
                                     else findPureSymbol sym clauses model
                                     where pure=isPure s clauses model

-- helper function which checks whether a symbol is pure by searching through all its occurences
isPure :: Symbol -> [Clause] -> Model -> Maybe Bool
isPure s clauses model
 | nrNeg==0=Just True               -- if number of occurences of the negated symbol is 0, assign it to true (it always appear positive)
 | nrPos==0=Just False
 | otherwise=Nothing
 --count number of positive and negative occurences, disregarding clauses than can already be evaluated to true
 --note that the disjunction function assigns false to unassigned variables
 where nrPos=sum[ length (filter (\x->x==s) clause)|clause<-clauses, not (elem True (disjunction clause model)) ]
       neg=negateSymbol s
       nrNeg=sum[ length(filter (\x->x==neg) clause)|clause<-clauses, not (elem True (disjunction clause model)) ]



-- This function finds a unit clause from a given list of clauses and a model of assignments.
-- It returns Just a tuple of a symbol and the truth value to assign to that symbol. If no unit
-- clause is found, it should return Nothing.
findUnitClause :: [Clause] -> Model -> Maybe (Symbol, Bool)
findUnitClause clauses model
    |all/=[]=let x=head(all) in if (isNegated x) then Just(getUnsignedSymbol x,False) else Just(x,True)
    |otherwise=Nothing
    --create a list of unit clauses
    where all=[fromJust x|clause<-clauses, let x=allButOne clause model, x/=Nothing]

--helper function which checks whether all symbols but one in a clause are assigned to False
--and returns that symbol if this is the case
allButOne :: Clause -> Model -> Maybe Symbol
allButOne clause model
  | length(notFalse)==1=let v=(head(notFalse)) in if snd(v)==Nothing then Just(fst(v)) else Nothing
  | otherwise=Nothing
  where notFalse=filter (\y->snd(y)/=Just False) (map (\x->(x,lookupAssignment2 x model)) clause)



-- This function check the satisfability of a sentence in propositional logic. It takes as input a
-- list of clauses in CNF, a list of symbols for the domain, and model.
-- It returns true if there is a model which satises the propositional sentence.
-- Otherwise it returns false.
dpll :: [Clause] -> [Symbol] -> Bool
dpll clauses symbols = dpllAux clauses symbols []

-- helper function for dpll to keep track of models
-- If earlyTerminate returns True, it is safe to use pLogicEvaluate even with a partial model
-- NOte: pLogicEvaluate assigns False to unassigned symbols
dpllAux :: [Clause] -> [Symbol] -> Model -> Bool
dpllAux clauses symbols model
    | earlyTerminate clauses model=pLogicEvaluate clauses model
    | pure /= Nothing=
      let (p,value)=fromJust pure
      in dpllAux clauses (filter (\x->x/=p) symbols) ((p,value):model)
    | unit /= Nothing=
      let (p,value)=fromJust unit
      in dpllAux clauses (filter (\x->x/=p) symbols) ((p,value):model)
    | otherwise=
      let p=head(symbols)
          rest=tail(symbols)
      in dpllAux clauses rest ((p,True):model) || dpllAux clauses rest ((p,False):model)
    where pure=findPureSymbol symbols clauses model
          unit=findUnitClause clauses model

-- This function serves as the entry point to the dpll function. It takes a list clauses in CNF as
-- input and returns true or false.
-- It uses the dpll function above to determine the satisability of its input sentence.
dpllSatisfiable :: [Clause] -> Bool
dpllSatisfiable clauses =dpll clauses (getSymbols [clauses])

----------TASK 5: EVALUATION (5 marks)--------------------------------------------------------------
-- EVALUATION
-- a knowledge base (i.e. a sentence in propositional
-- logic), and a query sentence. Both items should have their clauses in CNF representation
-- and should be assigned to the following respectively:
evalKB :: [Sentence]
evalKB = [[["-a","b","c"],["a","c","d"],["a","c","-d"],["a","-c","d"],["a","-c","-d"],["-b","-c","d"],
          ["-a","b","-c"],["-a","-b","c"],["S11"],["-P11"],["-S11","W12","W11","W21"],["-W12","S11"],
          ["-W11","S11"],["-W21","S11"],["-W12","-P12"],["-W21","-P21"],["-W11","-W21"],["-W11","-W12"]],
          [["e","f"],["-e"],["e","m"],["-2,-1"]],[["a,1"]]]

evalQuery :: Sentence
evalQuery = [["S11"]]

-- for dpll evaluation
-- Use refutation to check entailment (check a |= b by checking the unsatisfiability of a || not b)
-- If ttEntails return True (there is entailment), dpllSatisable should return False.
sat :: Sentence
sat=(concat evalKB)++[["-S11"]]

-- RUNTIMES
-- Enter the average runtimes of the ttEntails and dpllSatisable functions respectively

runtimeTtEntails :: Double
runtimeTtEntails = 0.35


runtimeDpll :: Double
runtimeDpll = 3.12
