# word_finder program for MIPS
#
# Written by Andra Zaharia, 15/10/2015
# Based on the word_finder.c from University of Edinburgh
# Inf2C-CS Coursework 1. Task A 
# ==========================================================================
# Prints the different words in a sentence

	#==================================================================
        # DATA SEGMENT
        #==================================================================
	.data
	#------------------------------------------------------------------
        # Constant strings for output messages
        #------------------------------------------------------------------
string:         .asciiz  "Enter string: "
newline:        .asciiz  "\n"
buffer: 	.space 100
        # TEXT SEGMENT  
        #==================================================================	
	.text
	
        #------------------------------------------------------------------
        # IS_DELIMITING_CHAR function
        #------------------------------------------------------------------
    
is_delimiting_char: 
	
	li $t0, ' '
	beq $t1, $t0, print
	
	li $t0, ','
	beq $t1, $t0, print	

	li $t0, '.'
	beq $t1, $t0, print	
	
	li $t0, '!'
	beq $t1, $t0, print
	
	li $t0, '?'
	beq $t1, $t0, print
	
	li $t0, '_'
	beq $t1, $t0, print

	li $t0, '-'
	beq $t1, $t0, print
	
	li $t0, '('
	beq $t1, $t0, print
	
	li $t0, ')'
	beq $t1, $t0, print
	
	li $t0, '\n'
	beq $t1, $t0, print	
	
	jr $ra
	
	#------------------------------------------------------------------
        # MAIN code block
        #------------------------------------------------------------------
	.globl main
        #==================================================================


main: 
	#prompt for input:
	
        
        la $a0, newline
	li $v0,4
	syscall
        
        #get string from user
        li $v0,8
        la $a0, buffer #load byte space into address
        li $a1, 100 # allot the byte space for string
        move $s0,$a0 #save string to s0
        syscall
        la $a0, string # Load address of string to find length.
        la $a2, string # Load address of string to use in the loop_string part.
        la $a3, string # Load address of string to use in print.
        la $t0, 0($a3)
 
        
strlen: 
	li $s1, 0 # initialize the count to zero

loop_strlen: 
	lb $t1, 0($a0) # load the next character into t1
	beqz $t1, loop_string # check for the null character and move to loop_string
	addi $a0, $a0, 1 # increment the string pointer
	addi $s1, $s1, 1 # increment the count
	j loop_strlen # return to the top of the loop
	
	
loop_string:
	beqz $s1, main_end # check for the null character and move to main_end
	lb $t1, 0($a2) # load next character into t1
	jal is_delimiting_char 
	addi $a2, $a2, 1 # increment the string pointer
	subi $s1, $s1, 1 # decrement the count 
	
	
print: 
	la $a0, newline
	li $v0,4
	syscall
	
	beq $t0, $t1, loop_string
	li $v0, 11
	syscall 
	
	addi $a3, $a3, 1
	j print
	
	
main_end:      
        li   $v0, 4           # print_string("\n");
        la   $a0, newline
        syscall

        li   $v0, 10          # exit()
        syscall
 