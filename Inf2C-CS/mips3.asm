#a0 source address, a1 target, a2 number of words
#copy array
           .data
           
words1:   .byte   1,2,3,4,5,6
words2:   .space  40
size:     .byte   6

          .text
          
 
          .globl main

                            
fcopy:
  li $t0,0
loop:
  beq $t0,$a2,done
  lw $t1,($a0)
  sw $t1,($a1)
  addi $a0,$a0,4
  addi $a1,$a1,4
  addi $t0,$t0,1
  j loop
 
done: 
  jr $ra  
   
main:
  la $a0,words1
  la $a1,words2
  lw $a2,size
  jal fcopy

end:
   li $v0,1
   la $t1,words2
   lw $a0,12($t1)  #print first element
   syscall
   li   $v0, 10          # exit()
   syscall
