// ==========================================================================
// Palindrome Finder
// ==========================================================================
// Prints the palindromes in an input sentence.
//
// Inf2C-CS Coursework 1. Task B 
// s1427590


#include <stdio.h>

int read_char() { return getchar(); }
void read_string(char* s, int size) { fgets(s, size, stdin); }

void print_char(int c)     { putchar(c); }   
void print_string(char* s) { printf("%s", s); }

//check if a word is palindrome
int isPalin(char word[],int nr)
{
    int i=0,j=nr-1;             //start comparing first and last character 
                                //(substract 1 to ignore \n)
    if(j==0) return 0;          // not a palindrome if there's ony one character
    while(i<=j)                 // stop when indexes meet
    {   // we can use -32 to convert upper and lower case, since our permitted characters don't clash

        if(word[i]!=word[j]&&(word[i]-32!=word[j])&&(word[i]!=word[j]-32)) 
           return 0;

        i++;                    //increment character from the left
        j--;                    //decrement from the right

    }
    return 1;

}

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


int main (int argc, char** argv) {
  
  char input_sentence[100];
  int i=0,j,k;
  char current_char;
    
  char word[20];
  int char_index, delimiting_char;
  
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
    char_index=0;
    
    int found =0;                               //no palindrome found at the beginning

    for(k=0; k<i; k++)  {		
    current_char = input_sentence[k];
    delimiting_char = is_delimiting_char(current_char);

    if(delimiting_char) {
      if (char_index > 0) {			//Avoids printing a blank line in case of consecutive delimiting characters.
        
 		                                //Puts an newline character so the next word in printed in a new line.
        if(isPalin(word,char_index)){           //check if word is palindrome and prints it if it is
        word[char_index++] = '\n';
        found=1;                                //at least one palindrome
        for(j=0; j<char_index; j++)  {    
          print_char(word[j]);  
        }
        }
        char_index = 0;
      }
    }
    else {
      word[char_index++] = current_char;
    }
  }

   if(found==0) print_string("No palindrome found\n");  //no palindromes
  }

  return 0;
}


//---------------------------------------------------------------------------
// End of file
//---------------------------------------------------------------------------
