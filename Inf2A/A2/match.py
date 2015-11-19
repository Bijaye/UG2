import re

p=".*[^s]$"
s="asset"
result=re.match(p,s)
if(result):
    print "yes"
else:
    print "no"
