 #Get words in a given string
          
               .data
prompt:        .asciiz  "input:\n"
outmsg:        .asciiz  "output:\n"
endc:           .ascii   "\n"

               .globl main
               .text
               
main:
    #promt for input
    li $v0,4
    la $a0,prompt
    syscall
    li $t1,0  #number of characters
    
loop:
       
    
    li $v0,12    #read_char in $v0
    syscall
    sw $v0,0($s1)  #store character
    addi $t1,1
    lw $t2,endc
    beq $v0,print
    j loop
    
 print:
   li $v0,4
   la $a0,outmsg
   syscall
   li $v0,4
   la $a0,$t1
   syscall
   
   li $v0,10
   syscall
    