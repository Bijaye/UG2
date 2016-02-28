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

-- Gets a list of all symbols in for all given sentences
getSymbols :: [Sentence] -> [Symbol]
getSymbols stmts = remDup(map getUnsignedSymbol (foldl (++) [] (foldl (++) [] stmts)) )  --concatenate symbols from sentences

-- Helper function to get a list without duplicates
remDup::[String]->[String]
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
-- Check if all the disjunctions are true
pLogicEvaluate :: Sentence -> Model -> Bool
pLogicEvaluate stmt model = foldl (&&) True (map  (foldl (||) False) values) where values=map (\a->disjunction a model) stmt

-- Helper function which returns a list of assignments for the given list of symbols
disjunction::Clause->Model->[Bool]
disjunction symbols model=[if isNegated x then not(fromMaybe True (lookupAssignment (getUnsignedSymbol x) model)) else (fromMaybe False (lookupAssignment x model))|x<-symbols]


-- This function checks the truth value of list of a propositional sentence using the symbols
-- assignments in the model. It returns true only when all sentences in the list are true.
plTrue :: [Sentence]-> Model -> Bool
plTrue sentences model =foldl (&&) True ([pLogicEvaluate x model|x<-sentences])

-- This function takes as input a knowledgebase (i.e. a list of propositional sentences),
-- a query (i.e. a propositional sentence), and a list of symbols.
-- IT recursively enumerates the models of the domain using its symbols to check if there
-- is a model that satisfies the knowledge base and the query. It returns a list of all such models.


ttCheckAll::[Sentence]->Sentence->[Symbol]->[Model]
ttCheckAll kb query symbols
  |elem Nothing ans=[]   --return the empty list if there is a case when the mdel satisfies the kb but not the query
  |otherwise=map (fromJust) (filter (\x->x/=Just []) ans)   --return the models if there is the case of entailment
 where ans=ttCheckAllAux kb query symbols []

--Auxiliary function for ttCheckAll. It returns the list of models that satisfies the knowledge base and the query.
--If a model does not satify the model, it does not matter so we just append [] to the answer
--If a model satisfies the kb but not the query, we return a value of Nothing, so we now the entailment failed
ttCheckAllAux::[Sentence]->Sentence->[Symbol]->Model->[Maybe Model]
ttCheckAllAux kb query [] model
    | plTrue kb model= if pLogicEvaluate query model then [Just model] else [Nothing]  --returning Nothing means the entailment fails
    | otherwise=[Just []]  --this is equivalent to returing true, when the model does not satisfy the kb
ttCheckAllAux kb query symbols model=(ttCheckAllAux kb query rest ((p,True):model))++(ttCheckAllAux kb query rest ((p,False):model))
                         where p=head(symbols)
                               rest=tail(symbols)


-- This function determines if a model satisfes both the knowledge base and the query, returning
-- true or false.
ttEntails :: [Sentence] -> Sentence -> Bool
ttEntails kb query
  |ttCheck==[]=False
  |otherwise=True
    where symbols=remDup ((getSymbols kb)++(getSymbols [query]))
          ttCheck=ttCheckAll kb query symbols


-- This function determines if a model satisfes both the knowledge base and the query.
-- It returns a list of all models for which the knowledge base entails the query.
ttEntailsModels :: [Sentence] -> Sentence -> [Model]
ttEntailsModels kb query =  ttCheckAll kb query symbols
     where symbols=remDup ((getSymbols kb)++(getSymbols [query]))


----------TASK 4: DPLL (43 marks)-------------------------------------------------------------------

-- The early termination function checks if a sentence is true or false even with a
-- partially completed model.
earlyTerminate :: Sentence -> Model -> Bool
earlyTerminate sentence model = undefined

-- This function finds pure symbol, i.e, a symbol that always appears with the same "sign" in all
-- clauses.
-- It takes a list of symbols, a list of clauses and a model as inputs.
-- It returns Just a tuple of a symbol and the truth value to assign to that
-- symbol. If no pure symbol is found, it should return Nothing
findPureSymbol :: [Symbol] -> [Clause] -> Model -> Maybe (Symbol, Bool)
findPureSymbol symbols clauses model = undefined

-- This function finds a unit clause from a given list of clauses and a model of assignments.
-- It returns Just a tuple of a symbol and the truth value to assign to that symbol. If no unit
-- clause is found, it should return Nothing.
findUnitClause :: [Clause] -> Model -> Maybe (Symbol, Bool)
findUnitClause clauses model = undefined


-- This function check the satisfability of a sentence in propositional logic. It takes as input a
-- list of clauses in CNF, a list of symbols for the domain, and model.
-- It returns true if there is a model which satises the propositional sentence.
-- Otherwise it returns false.
dpll :: [Clause] -> [Symbol] -> Bool
dpll clauses symbols = undefined

-- This function serves as the entry point to the dpll function. It takes a list clauses in CNF as
-- input and returns true or false.
-- It uses the dpll function above to determine the satisability of its input sentence.
dpllSatisfiable :: [Clause] -> Bool
dpllSatisfiable clauses = undefined

----------TASK 5: EVALUATION (5 marks)--------------------------------------------------------------
-- EVALUATION
-- a knowledge base (i.e. a sentence in propositional
-- logic), and a query sentence. Both items should have their clauses in CNF representation
-- and should be assigned to the following respectively:
evalKB :: [Sentence]
evalKB = undefined

evalQuery :: Sentence
evalQuery = undefined


-- RUNTIMES
-- Enter the average runtimes of the ttEntails and dpllSatisable functions respectively
runtimeTtEntails :: Double
runtimeTtEntails = undefined

runtimeDpll :: Double
runtimeDpll = undefined