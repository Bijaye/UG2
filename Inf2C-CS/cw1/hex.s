#=========================================================================
# Decimal to Hex calculator
#=========================================================================
# Print a number in hexadecimal, digit by digit.
# 
# Inf2C Computer Systems
# 
# Paul Jackson
#  8 Oct 2013
# 
# Based on program written by Aris Efthymiou, in turn derived from
# program from U. of Manchester for the ARM ISA
#
# MIPS comments show how code corresponds to an equivalent C program.
# C comments within MIPS comments are used to add further details on
# the operation of the MIPS code and the use of registers.
        
        #==================================================================
        # DATA SEGMENT
        #==================================================================
        .data
        #------------------------------------------------------------------
        # Constant strings for output messages
        #------------------------------------------------------------------

prompt1:        .asciiz  "Enter decimal number: "
outmsg:         .asciiz  "\nThe number in hex is: "
newline:        .asciiz  "\n"
x:    .word 23

        
        #------------------------------------------------------------------
        # Global variables in memory
        #------------------------------------------------------------------
        # None for this program.  Registers used instead.
        
        #==================================================================
        # TEXT SEGMENT  
        #==================================================================
        .text

        #------------------------------------------------------------------

        #------------------------------------------------------------------

        .globl main           # Declare main label to be globally visible.
                              # Needed for correct operation with MARS
main:
        
       
        la $s1,x
        lw   $a0,x


main_end:      
        li   $v0, 1          # print_string("\n"); 
        syscall

        li   $v0, 10          # exit()
        syscall

        #----------------------------------------------------------------
        # END OF CODE
        #----------------------------------------------------------------
