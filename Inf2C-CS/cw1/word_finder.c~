// ==========================================================================
// Word Finder
// ==========================================================================
// Prints the different words in a sentence

// Inf2C-CS Coursework 1. Task A 
// PROVIDED file, to be used as model for writing MIPS code.

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
// Check if the current character is a delimiting character
//---------------------------------------------------------------------------

int is_delimiting_char(char ch)
{
  if(ch == ' ')			//White space
    return 1;
  else if(ch == ',')		//Comma
    return 1;
  else if(ch == '.')		//Period
    return 1;
  else if(ch == '!')		//Exclamation
    return 1;
  else if(ch == '?')		//Question mark
    return 1;
  else if(ch == '_')		//Underscore
    return 1;
  else if(ch == '-')		//Hyphen
    return 1;
  else if(ch == '(')		//Opening parentheses
    return 1;
  else if(ch == ')')		//Closing parentheses
    return 1;
  else if(ch == '\n')		//Newline (the input ends with it)
    return 1;
  else
    return 0;
}

//---------------------------------------------------------------------------
// MAIN function
//---------------------------------------------------------------------------

int main (void)
{
  char input_sentence[100];
  int i=0,j,k;
  char current_char;
    
  char word[20];
  int char_index, delimiting_char;
   
  /////////////////////////////////////////////
  
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
  char_index = 0;

  /* The loop goes over the input sentence one character at a time.
   * Looks for delimiting characters to detect the word boundries and
   * print the words on screen.
   */
  for(k=0; k<i; k++)  {		
    current_char = input_sentence[k];
    delimiting_char = is_delimiting_char(current_char);

    if(delimiting_char) {
      if (char_index > 0) {			//Avoids printing a blank line in case of consecutive delimiting characters.
        word[char_index++] = '\n';		//Puts an newline character so the next word in printed in a new line.
        for(j=0; j<char_index; j++)  {    
          print_char(word[j]);  
        }
        char_index = 0;
      }
    }
    else {
      word[char_index++] = current_char;
    }
  }


  /////////////////////////////////////////////
   
  return 0;
}

//---------------------------------------------------------------------------
// End of file
//---------------------------------------------------------------------------

