        #==================================================================
        # DATA SEGMENT
        #==================================================================
        .data
        #------------------------------------------------------------------
        # Constant strings for output messages
        #------------------------------------------------------------------
prompt:         .asciiz  "input: "
outmsg:         .asciiz  "output:\n"
newline:        .byte  '\n' 
        #------------------------------------------------------------------
        # Global variables in memory
        #------------------------------------------------------------------
        
input_sentence: .space 100   #char input_sentence[100];
word:           .space 20    #char word[20];
          

  
        .text  
            
                       # int is_delimiting_char(char ch)
                       #{
                       # //ch in $a0
                       #
is_delimiting_char:    #if(ch == ' ')	
   li $t1, ' '         # //' ' in $t1
   seq $v0,$a0,$t1     # //$v0=0  if $a0=$t1
   bnez $v0,done       # //go to done if $v0!=0 (if statement is true)
                       #   return 1;
   li $t1, ','         # else if(ch == ',')
   seq $v0,$a0,$t1     #   return 1;
   bnez $v0,done
   
   li $t1, '.'         # else if(ch == '.')
   seq $v0,$a0,$t1
   bnez $v0,done       #   return 1;
   
   li $t1, '!'         # else if(ch == '!')
   seq $v0,$a0,$t1
   bnez $v0,done       #   return 1;
   
   li $t1, '?'         # else if(ch == '?')
   seq $v0,$a0,$t1
   bnez $v0,done       #   return 1;
   
   li $t1, '_'         # else if(ch == '_')
   seq $v0,$a0,$t1
   bnez $v0,done       #   return 1;
   
   li $t1, '-'         # else if(ch == '-')
   seq $v0,$a0,$t1
   bnez $v0,done       #   return 1;
   
   li $t1, '('         #else if(ch == '(')
   seq $v0,$a0,$t1
   bnez $v0,done       #   return 1;
    
   li $t1, ')'         # else if(ch == ')')
   seq $v0,$a0,$t1
   bnez $v0,done       #   return 1;
   
   li $t1, '\n'        #else if(ch == '\n')
   seq $v0,$a0,$t1
   bnez $v0,done       #  return 1;
                       #else
   jr $ra              #  return 0;
done:   
   jr $ra   

print_space:
   li $t1,'\n'
   sb $t1,0($s4) 
   addi $s4,$s4,1 #increase index
   addi $s3,$s3,1 
   j continue
                    
   .globl main                                                 
main:

     #prompt for input
     li $v0,4   
     la $a0,prompt
     syscall
     
     #get string from user and store in input_sentence 
     li $v0,8
     la $a0,input_sentence
     li $a1,100
     syscall
     #output
     li $v0,4
     la $a0,outmsg
     syscall
     
     la $s0,input_sentence
 
  
initialize:
  li $s2,0 #loop variable; length is s1
  li $s3,0 #char index
  la $s4,word #store word
  li $s5,0
    
loop_chars:
  lb $a0,0($s0)
  beqz $a0,end
  jal is_delimiting_char
  beqz $v0, increase_index  #not delimiting character, keep going
  j print_one

increase_index:
 
  sb $a0,0($s4) 
  addi $s4,$s4,1 #increase index
  addi $s0,$s0,1 
  addi $s3,$s3,1
  
  j loop_chars
  
               
print_one:
  bnez $s3,print_space
continue:        
  sub $s4,$s4,$s3
  li $s5,0 #counter for printing
  j print_loop

print_loop:
  beq $s5,$s3, doneWord
  li $v0,11
  lb $a0,0($s4)
  syscall
  addi $s5,$s5,1
  addi $s4,$s4,1
  j print_loop
   
doneWord:
 addi $s0,$s0,1 
 j initialize
  
                        
end:  
    li $v0,10
    syscall
