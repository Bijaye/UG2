# File: statements.py
# Template file for Informatics 2A Assignment 2:
# 'A Natural Language Query System in Python/NLTK'

# John Longley, November 2012
# Revised November 2013 and November 2014 with help from Nikolay Bogoychev
# Revised November 2015 by Toms Bergmanis and Shay Cohen


# PART A: Processing statements

def add(lst,item):
    if (item not in lst):
        lst.insert(len(lst),item)

class Lexicon:
    """stores known word stems of various part-of-speech categories"""
    # add code here
    def __init__(self):
        self.lex=[]
    def add(self,stem,cat):
        self.lex.append((stem,cat))
    def getAll(self,cat):
        result=[]
        for el in self.lex:
            if(el[1]==cat):
                add(result,(el[0])) 
        return result


class FactBase:
    # add code here
    def __init__(self):
        self.unaries=[]
        self.binaries=[]
    def addUnary(self,pred,e1):
        self.unaries.append((pred,e1))
    def addBinary(self,pred,e1,e2):
        self.binaries.append((pred,e1,e2))
    def queryUnary(self,pred,e1):
        return (pred,e1) in self.unaries
    def queryBinary(self,pred,e1,e2):
        return (pred,e1,e2) in self.binaries

lx=Lexicon()
lx.add("John","P")
lx.add("John","P")
lx.add("Mary","P")
lx.add("Mary","N")
print lx.lex
print lx.getAll("P")
fb=FactBase()
fb.addBinary("love","John","Mary")
print fb.queryBinary("love","John","Mary")

import re
from nltk.corpus import brown 
def verb_stem(s):
    """extracts the stem from the 3sg form of a verb, or returns empty string"""
    # add code here

def add_proper_name (w,lx):
    """adds a name to a lexicon, checking if first letter is uppercase"""
    if ('A' <= w[0] and w[0] <= 'Z'):
        lx.add(w,'P')
        return ''
    else:
        return (w + " isn't a proper name")

def process_statement (lx,wlist,fb):
    """analyses a statement and updates lexicon and fact base accordingly;
       returns '' if successful, or error message if not."""
    # Grammar for the statement language is:
    #   S  -> P is AR Ns | P is A | P Is | P Ts P
    #   AR -> a | an
    # We parse this in an ad hoc way.
    msg = add_proper_name (wlist[0],lx)
    if (msg == ''):
        if (wlist[1] == 'is'):
            if (wlist[2] in ['a','an']):
                lx.add (wlist[3],'N')
                fb.addUnary ('N_'+wlist[3],wlist[0])
            else:
                lx.add (wlist[2],'A')
                fb.addUnary ('A_'+wlist[2],wlist[0])
        else:
            stem = verb_stem(wlist[1])
            if (len(wlist) == 2):
                lx.add (stem,'I')
                fb.addUnary ('I_'+stem,wlist[0])
            else:
                msg = add_proper_name (wlist[2],lx)
                if (msg == ''):
                    lx.add (stem,'T')
                    fb.addBinary ('T_'+stem,wlist[0],wlist[2])
    return msg
                        
# End of PART A.

