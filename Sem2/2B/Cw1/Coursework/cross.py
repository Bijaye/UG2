import sys
cross=0
(name,file)=sys.argv
file="matcherTimes"+str(file)+".txt"
with open(file,'r') as f:
    next(f)
    for line in f:
        (a,b,n,k)=line.split()
        if(int(k)>int(n)):
            cross=b
             

print cross
