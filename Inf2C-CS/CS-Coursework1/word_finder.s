        #// ==========================================================================
        #// Palindrome Finder
        #// ==========================================================================
        #// Prints the palindromes in an input sentence.
        #//
        #// Inf2C-CS Coursework 1. Task B 
        #// s1427590 
        #==================================================================
        # DATA SEGMENT
        #==================================================================
                 .data
        #------------------------------------------------------------------
        # Constant strings for output messages
        #------------------------------------------------------------------

prompt:         .asciiz  "input: "
outmsg:         .asciiz  "output:\n"

        #------------------------------------------------------------------
        # Global variables in memory       
        #------------------------------------------------------------------
        
input_sentence: .space 100     #char input_sentence[100];
word:           .space 20      #char word[20];
          
    
  
                .text  
                               # int is_delimiting_char(char ch)
                               # {
                               # //ch in $a0
                               #
is_delimiting_char:            
   li $t1, ' '                 # //' ' in $t1
   beq $a0,$t1,isDelim         # if(ch == ' ')	
                               #   return 1;
   li $t1, ','                 # else if(ch == ',')
   beq $a0,$t1,isDelim         #   return 1;
  
   li $t1, '.'                 # else if(ch == '.')
   beq $a0,$t1,isDelim         #   return 1;             
 
   li $t1, '!'                 # else if(ch == '!')
   beq $a0,$t1,isDelim         #   return 1;
   
   li $t1, '?'                 # else if(ch == '?')
   beq $a0,$t1,isDelim         #   return 1;  
              
   li $t1, '_'                 # else if(ch == '_')
   beq $a0,$t1,isDelim         #   return 1;
                 
   li $t1, '-'                 # else if(ch == '-')
   beq $a0,$t1,isDelim         #   return 1;
                
   li $t1, '('                 #else if(ch == '(')
   beq $a0,$t1,isDelim         #   return 1;
                 
   li $t1, ')'                 # else if(ch == ')')
   beq $a0,$t1,isDelim         #   return 1;
                 
   li $t1, '\n'                #else if(ch == '\n')
   beq $a0,$t1,isDelim         #   return 1;
                
   li $v0,0                    #else
   jr $ra                      #  return 0;  //return to caller with $v0=0

isDelim: 
   li $v0,1 
   jr $ra                      # //used to return to caller with $v0=1

                    
   .globl main         
                                           
main:
                               #char input_sentence[100];   // in input_sentence
                               #int i=0,j,k;               //
                               #char current_char;
    
   la $s4,word                 #char word[20];
                               #int char_index, delimiting_char; //use $s3 for char_index, $v0 for delimiting_char
     
   li $v0,4                    # print_string("input: ");
   la $a0,prompt
   syscall
     
                               # do {           
                               #current_char=read_char();
                               #input_sentence[i]=current_char;
                               #i++;
                               #} while (current_char != '\n');
     
   li $v0,8                    # //read entire string at once
   la $a0,input_sentence       # //use $a0 as buffer 
   li $a1,100                  # //use $a1 as size
   syscall
   la $s0,input_sentence       #//store input_sentence in $s0
    
     
   li $v0,4                    # print_string("output:\n");
   la $a0,outmsg
   syscall
     
   li $s3,0                    # char_index = 0;
    
 
   
    
loop_chars:
                               # for(k=0; k<i; k++)  {	
  lb $a0,0($s0)                # current_char = input_sentence[k];
  beqz $a0,end                 # //check for loop end condition
loop_chars_body:               # //move to next character in input_sentence (k++) 
  jal is_delimiting_char       # delimiting_char = is_delimiting_char(current_char);
                               # call is_delimiting_char, passing $a0 which holds current_char as argument

  bnez $v0, print_one          # if(delimiting_char) {
  j increase_index
  
print_one:
  bnez $s3,print_loop_start    # if (char_index > 0) {
  j done_print


print_loop_start:   
  li $t1,'\n'                 
  sb $t1,0($s4)                # word[char_index++] = '\n';
  addi $s4,$s4,1               # //get next character from word
  addi $s3,$s3,1               # //char_index++          
  li $s5,0                     # //j=0, prepare to get first character of word
  la $s4,word
print_loop:                    # for(j=0; j<char_index; j++) {
  beq $s5,$s3, done_print      # //check end cndition
  j print_loop_body            # print_char(word[j]); 
print_loop_body:
  addi $s5,$s5,1               # //j++  
  li $v0,11
  lb $a0,0($s4)                # //get to word[j]
  syscall
  addi $s4,$s4,1               # //move to next character in input_sentence k++
  j print_loop                 # }

done_print:                   
  li $s3,0                     # char_index = 0;
  la $s4,word                  #  }
  addi $s0,$s0,1
  j loop_chars                 #   }
   
increase_index:         
  lb $t0,0($s0)                # else {
  sb $t0,0($s4)                # word[char_index++] = current_char;
  addi $s4,$s4,1               # //move to next character of the word
  addi $s3,$s3,1               # //increase char_index
  addi $s0,$s0,1               # //get next character input_sentence k++
  j loop_chars                 # //contiune for loop
   
end:  
    li $v0,10
    syscall
