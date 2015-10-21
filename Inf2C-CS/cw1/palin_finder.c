// ==========================================================================
// Palindrome Finder
// ==========================================================================
// Prints the palindromes in an input sentence.
//
// Inf2C-CS Coursework 1. Task B 
// OUTLINE code, to be completed as part of coursework.

// Boris Grot, Rakesh Kumar
//  12 Oct 2015

//---------------------------------------------------------------------------
// C definitions for SPIM system calls
//---------------------------------------------------------------------------
#include <stdio.h>

int read_char() { return getchar(); }
void read_string(char* s, int size) { fgets(s, size, stdin); }

void print_char(int c)     { putchar(c); }   
void print_string(char* s) { printf("%s", s); }


//---------------------------------------------------------------------------
// Functions
//---------------------------------------------------------------------------

// TO BE COMPLETED

//---------------------------------------------------------------------------
// MAIN function
//---------------------------------------------------------------------------


int main (int argc, char** argv) {
  
  char input_sentence[100];  
  int i=0;
  char current_char;
  
  /////////////////////////////////////////////    
        

  
  /////////////////////////////////////////////
  
  /* Infinite loop 
   * Asks for input sentence and prints the palindromes in it
   * Terminated by user (e.g. CTRL+C)
   */

  while(1) {
    
    i=0;       
        
    print_char('\n'); 
    
    print_string("input: ");

    /* Read the input sentence. 
     * It is just a sequence of character terminated by a new line (\n) character.
     */
  
    do {           
      current_char=read_char();
      input_sentence[i]=current_char;
      i++;
    } while (current_char != '\n');
          
    /////////////////////////////////////////////     
    
       
    print_string("output:\n");          
      
    // TO BE COMPLETED 
    
    /////////////////////////////////////////////
    
  }

  return 0;
}


//---------------------------------------------------------------------------
// End of file
//---------------------------------------------------------------------------
