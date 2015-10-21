                .data
prompt:         .asciiz  "input: "
outmsg:         .asciiz  "output:\n"
list:           .space 100
word:           .space 20
newline:        .byte  '\n'             
                .text

                    
                  .globl main                                                 
main:

     #prompt for input
     li $v0,4   
     la $a0,prompt
     syscall
     
     #get string from user and store in list 
     li $v0,8
     la $a0,list
     li $a1,100
     syscall
     
     #output
     li $v0,4
     la $a0,outmsg
     syscall
     
     la $s0,list
     
      li $v0,4
     la $a0,list
     syscall
  

                        
end:
    li $v0,10
    syscall
