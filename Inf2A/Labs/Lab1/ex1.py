import re

def testMatch(s):
    return re.findall("[a-z]*ly",s)

def replaceWH(s):
    return re.sub("wh[a-z]*","WH-word",s)

print testMatch("it is likely to happen rarely")

print replaceWH("who should do that")
print replaceWH("who am I and what I am doing and where")

print re.sub("dd","x","ddd")

b= re.match("(aa|bb)+","caabbaa")
if b!=None:
    print "yes"
else:
    print "no"
