        #==================================================================
        # DATA SEGMENT
        #==================================================================
                 .data
        #------------------------------------------------------------------
        # Constant strings for output messages
        #------------------------------------------------------------------
prompt:         .asciiz  "input: "
outmsg:         .asciiz  "output:\n"
newline:        .byte    '\n' 
none:           .asciiz  "No palindrome found\n"
        #------------------------------------------------------------------
        # Global variables in memory       
        #------------------------------------------------------------------
        
input_sentence: .space 100     #char input_sentence[100];
word:           .space 20      #char word[20];
          
    
  
                 .text  
            
                               # int is_delimiting_char(char ch)
                               #{
                               # //ch in $a0
                               #
is_delimiting_char:            
   li $t1, ' '                 # //' ' in $t1
   beq $a0,$t1,isDelim         #if(ch == ' ')	
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

is_palindrome:
                               #//start of word in $a0
    li $t0,0                   # int i=0 //i in $t0
    addi $t1,$a1,-1            # //j=char_index-1 to ignore \n in $t1
    beq $t1,$zero,pal_false        # if(j==0) return 0;
    la $t2,($a0)               # //go to first character
    add $t2,$t2,$t1            # //go to last character of the word

pal_loop:
    sle $v0,$t0,$t1            # while(i<=j){
    beq $v0,0,pal_true              # //return 1 because there was no return 0;
    lb $t3,0($a0)              # //get word[i]
    lb $t4,0($t2)              # //get word[j]
                               # if(word[i]!=word[j]&&(word[i]-32!=word[j])&&(word[i]!=word[j]-32))
    sne $t5, $t3,$t4           # //$t5 is 1 if word[i]!=word[j
    addi $t3,$t3,-32           # //word[i]-32 in $t3
    sne $t6, $t3,$t4           # //$t6 is 1 if word[i]-32!=word[j]
    and $t5,$t5,$t6            # //$t5 is $t5&&t6
    addi $t3,$t3,32            # //get back word[i]
    addi $t4,$t4,-32           # //word[j]-32 in $t4
    sne $t6, $t3,$t4           # //(word[i]!=word[j]-32)
    and $t5,$t5,$t6            # //check all conditions
    addi $t4,$t4,32
    bne $t5,$zero,pal_false    # //return 0
    addi $t0,$t0,1             # i++;
    addi $t1,$t1,-1            # j--;
    addi $a0,$a0,1
    addi $t2,$t2,-1            #  }
                               # return 1;
    j pal_loop                 # }
    
       
pal_false:
   li $v0,0
   jr $ra  
pal_true:
   li $v0,1
   jr $ra                                                          
                    .globl main         
                                           
main:
                               # char input_sentence[100];   // in input_sentence
                               # int i=0,j,k;               //
                               # char current_char;
    
   la $s4,word                 # char word[20];
                               # int char_index, delimiting_char; //use $s3 for char_index, $v0 for delimiting_char
                               # while(1) {
   li $v0,11
   li $a0,'\n'                 # print_char('\n'); 
   syscall     
   li $v0,4                    # print_string("input: ");
   la $a0,prompt
   syscall
     
                               # do {           
                               # current_char=read_char();
                               # input_sentence[i]=current_char;
                               # i++;
                               # } while (current_char != '\n');
     
   li $v0,8                    # //read entire string at once
   la $a0,input_sentence       # //use $a0 as buffer 
   li $a1,100                  # //use $a1 as size
   syscall
   la $s0,input_sentence       # //store input_sentence in $s0
    
     
   li $v0,4                    # print_string("output:\n");
   la $a0,outmsg
   syscall
     
   li $s3,0                    # char_index = 0;
   li $s6,0                    # int found=0;
    
 
 
     
    
loop_chars:
                               # for(k=0; k<i; k++)  {	
  lb $a0,0($s0)                # current_char = input_sentence[k];
  beqz $a0,check_found                # //infinite loop
loop_chars_body:               # //move to next character in input_sentence (k++) 
  jal is_delimiting_char       # delimiting_char = is_delimiting_char(current_char);
                               # call is_delimiting_char, passing $a0 which holds current_char as argument

  bnez $v0, check_pal          # if(delimiting_char) {  //we obtained a word from the sentence, process it
  j increase_index             # //else statement
 
check_pal:     
  beqz $s3, done_print         # if (char_index > 0) {
  la $a0,word
  addi $a1,$s3,0               # //store char_index in $a1
  jal is_palindrome            # call is_palindrome with $a0 as word and $a1 as index
  beqz $v0,done_print          # if(isPalin(word,char_index))
                               # {

print_start:   
  li $t1,'\n'                  # word[char_index++] = '\n';
  sb $t1,0($s4)               
  addi $s4,$s4,1               # //get next character from word
  addi $s3,$s3,1               # //char_index++  
  li $s6,1                     # found=1       
  li $s5,0                     # //j=0, prepare to get first character of word
  la $s4,word
  
print_loop:                    # for(j=0; j<char_index; j++) {
  beq $s5,$s3, done_print
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
  addi $s0,$s0,1               # //move to next character k++
  j loop_chars                #   }
   
increase_index:         
  lb $t0,0($s0)                # else {
  sb $t0,0($s4)                # word[char_index++] = current_char;
  addi $s4,$s4,1               # //move to next character of the word
  addi $s3,$s3,1               # //increase char_index)
  addi $s0,$s0,1               # //get next character input_sentence k++
  j loop_chars                 # //contiune for loop
  
check_found:                 
  bnez,$s6,main                # if(found==0) print_string("No palindrome found\n");
  li $v0,4                     # //if found!=0 get next sentence  
  la $a0,none
  syscall 
  j main                       # } }
  