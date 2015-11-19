# File: statements.py
# Template file for Informatics 2A Assignment 2:
# 'A Natural Language Query System in Python/NLTK'

# John Longley, November 2012
# Revised November 2013 and November 2014 with help from Nikolay Bogoychev
# Revised November 2015 by Toms Bergmanis and Shay Cohen


# PART A: Processing statements

from nltk.corpus import brown

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

lx=Lexicon()

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

fb=FactBase()

import re
from nltk.corpus import brown 
def verb_stem(s):
    """extracts the stem from the 3sg form of a verb, or returns empty string"""
    # add code here
    
    #rule 1
    if(re.match("\w*([^aeiousxyzh]|[^cs]h)s$",s)):
        res=s[:-1]
    #rule 2
    elif(re.match("\w*[aeiou]ys$",s)):
        res=s[:-1]
    #rule 3
    elif(re.match("\w+[^aeiou]ies$",s)):
        res=s[:-3]+"y"
    #rule 4
    elif(re.match("^\wies$",s)):
        res=s[:-1]
    #rule 5
    elif(re.match("\w*(o|x|ch|sh|ss|zz)es$",s)):
        res=s[:-2]
    #rule 6
    elif(re.match("\w*(([^s]se)|([^z]ze))s$",s)):
        res=s[:-1]
    #rule 7
    elif(s=="has"):
        res="have"
    #rule 8
    elif(re.match("\w*([^iosxzh]|[^cs]h)es$",s)):
        res=s[:-1]
    else:
        res=""
    if(s=="has" or s=="does"):
        return res
    elif((res,"VB") in brown.tagged_words() or (s,"VBZ") in brown.tagged_words()):
        return res
    else:
        return ""

#tests=["misses","cats","has","have","does","eats","cries","pays","tells","shows","ies","flies","lies","ties","diesgsha","goies","goes","washes",
#"boxes","fizzes","es","sses","dazzles","loses","dazes","analyses","passes","lapses","likes","hates","bathes","flys","unties"]

#print verb_stem("assesses")

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

print process_statement(lx,["Mary","is","a","duck"],fb)
print process_statement(lx,["Ramy","eats"],fb)
print process_statement(lx,["Anca","loves","Mickey"],fb)
for i in lx.lex:
    print i,
print fb.queryUnary("N_duck","Mary")
print fb.unaries
print fb.binaries