# Prints a number in hexadecimal, digit by digit.
# 
# Written by Aris Efthymiou, 16/08/2005
# Based on hex.s program from U. of Manchester for the ARM ISA

        .data
prompt1:        .asciiz  "Enter decimal number.\n"
outmsg:         .asciiz  "The number in binary representation is:\n"

        .globl main

        .text
main:   
        # prompt for input
        li   $v0, 4
        la   $a0, prompt1
        syscall

        # Get number from user
        li   $v0, 5
        syscall

        add  $s0, $zero, $v0  # Keep the number in $s0,

        # Output message
        li   $v0, 4
        la   $a0, outmsg
        syscall

        # set up the loop counter variable
        li   $t0, 32  # 8 hex digits in a 32-bit number
        li $t3,31

        # Main loop
        
#get rid of leading 0s

loop1:  srl $t4,$s0,31
        bne $t4,$0,next  #if no more leading zeros go to next loop
        sll $s0,$s0, 1   #if it is a zero, shift left to get rid of it
        addi $t0,$t0,-1  #less digits to care about in the loop
        j loop1          #no 1 found yet, loop again
        
next:    
loop:   srl  $t1, $s0, 31  # get leftmost digit by shifting it
                         
        
        # Print one digit
print:  li   $v0, 1
        add  $a0, $zero, $t1
        syscall          # Print int in $a0
        # Prepare for next iteration
        sll  $s0, $s0, 1   # Drop current leftmost digit
        addi $t0, $t0, -1  # Update loop counter
        bne  $t0, $zero, loop # Still not 0?, go to loop

        # end the program
        li   $v0, 10
        syscall

