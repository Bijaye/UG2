# File: pos_tagging.py
# Template file for Informatics 2A Assignment 2:
# 'A Natural Language Query System in Python/NLTK'

# John Longley, November 2012
# Revised November 2013 and November 2014 with help from Nikolay Bogoychev
# Revised November 2015 by Toms Bergmanis and Shay Cohen


# PART B: POS tagging

from statements import *
import re

# The tagset we shall use is:
# P  A  Ns  Np  Is  Ip  Ts  Tp  BEs  BEp  DOs  DOp  AR  AND  WHO  WHICH  ?

# Tags for words playing a special role in the grammar:

function_words_tags = [('a','AR'), ('an','AR'), ('and','AND'),
     ('is','BEs'), ('are','BEp'), ('does','DOs'), ('do','DOp'), 
     ('who','WHO'), ('which','WHICH'), ('Who','WHO'), ('Which','WHICH'), ('?','?')]
     # upper or lowercase tolerated at start of question.

function_words = [p[0] for p in function_words_tags]

def unchanging_plurals():
    nouns={}
    res=[]
    with open("sentences.txt", "r") as f:
        for line in f:
            # add code here
            words=line.split(" ")
            for pair in words:
                w,c=pair.split("|")
                if(c=="NN"):
                    if(nouns.get(w)=="NNS"):
                        res.append(w)
                    else:
                        nouns[w]=c
                if(c=="NNS"):
                    if(nouns.get(w)=="NN"):
                        res.append(w)
                    else:
                        nouns[w]=c
    return list(set(res))


unchanging_plurals_list = unchanging_plurals()


def noun_stem (s):
    """extracts the stem from a plural noun, or returns empty string"""    
    # add code here
    if(s in unchanging_plurals_list):
        return s
    elif(re.match(".*men$",s)):
        return s[:-2]+"an"
    #other rules
    elif(re.match("\w*([^aeiousxyzh]|[^cs]h)s$",s)):
        return s[:-1]
    elif(re.match("\w*[aeiou]ys$",s)):
        return s[:-1]
    elif(re.match("\w+[^aeiou]ies$",s)):
        return s[:-3]+"y"
    elif(re.match("^\wies$",s)):
        return s[:-1]
    elif(re.match("\w*(o|x|ch|sh|ss|zz)es$",s)):
        return s[:-2]
    elif(re.match("\w*(([^s]se)|([^z]ze))s$",s)):
        return s[:-1]
    elif(re.match("\w*([^iosxzh]|[^cs]h)es$",s)):
        return s[:-1]
    else:
        return ""


def tag_word (lx,wd):
    """returns a list of all possible tags for wd relative to lx"""
    # add code here
    result=[]
    all_P=lx.getAll("P")
    all_A=lx.getAll("A")
    all_I=lx.getAll("I")
    all_N=lx.getAll("N")
    all_T=lx.getAll("T")
    nn=noun_stem(wd)
    vb=verb_stem(wd)
    if wd in function_words:
        for p in function_words_tags:
            if(p[0]==wd):
                result.append(p[1])
    if(wd in all_P):
        result.append("P")
    if(wd in all_A):
        result.append("A")
    if(wd in all_I):
       result.append("Ip")
    if(vb in all_I):
        result.append("Is")
    if(wd in all_T):
        result.append("Tp")
    if(vb in all_T):
        result.append("Ts")
    if(wd in all_N):
       result.append("Ns")
    if(nn in all_N):
        result.append("Np")
    return result


def tag_words (lx, wds):
    """returns a list of all possible taggings for a list of words"""
    if (wds == []):
        return [[]]
    else:
        tag_first = tag_word (lx, wds[0])
        tag_rest = tag_words (lx, wds[1:])
        return [[fst] + rst for fst in tag_first for rst in tag_rest]

# End of PART B.
