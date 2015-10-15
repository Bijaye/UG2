

                .data
prompt:         .asciiz  "Enter chars: "
outmsg:         .asciiz  "\nOutput: "
newline:        .byte  '\n'
list:           .word 400

                .text
                
main:

     li $v0,4
     la $a0,prompt
     syscall
     li $s1,0  #number of characters
     la $s2,list
     addi $sp,$sp, -4 #adjust stack for 1 item
     sw $s2,0($sp)
     li $s3,0

read_loop:
    li $v0,12   ##prepare to read_char
    syscall
    move $t1,$v0
    sw   $t1,0($s2)
    addi $s1,$s1,1  #increment counter
    addi $s2,$s2,4 #next character in the array
    lb   $t0,newline  #check if we reached end of line
    beq  $t1,$t0,done_reading  #if end of line, we're done reading
    j read_loop  #else, read another character
     
done_reading:
    lw $s2,0($sp)   #get start of string
    addi $sp,$sp,4
    li $v0,1        #prepare to print_int
    addi $a0,$s1,-1  #decrement 1 to get correct length
    syscall   #print length of string
      
print:  #prints first character. 
#TO-DO:loop
    li $v0,11
    lw $a0,0($s2)
    syscall
   
    
   
    
end_main:    
    li $v0,10
    syscall