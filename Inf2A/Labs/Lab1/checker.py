def checkPrefix(list,prefix):
    for word in list:
        if(word[0:2]==prefix):
            print "*"+word
        else:
            print word


#import checker
#checker.checkPrefix(["who",ra"],"ra")
