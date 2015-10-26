
// File:   MH_Parser.java
// Date:   October 2015

// Java template file for parser component of Informatics 2A Assignment 2 (2015).
// Students should add a method body for the LL(1) parse table for Micro-Haskell.


import java.io.* ;
 
class MH_Parser extends GenParser implements PARSER {

    String startSymbol() {return "#Prog" ;}

    // Right hand sides of all productions in grammar:

    String[] epsilon              = new String[] { } ;
    String[] Decl_Prog            = new String[] {"#Decl", "#Prog"} ;
    String[] TypeDecl_TermDecl    = new String[] {"#TypeDecl", "#TermDecl"} ;
    String[] TypeDecl_rule        = new String[] {"VAR", "::", "#Type", ";"} ;
    String[] Type1_TypeOps        = new String[] {"#Type1", "#TypeOps"} ;
    String[] arrow_Type           = new String[] {"->", "#Type"} ;
    String[] Integer              = new String[] {"Integer"} ;
    String[] Bool                 = new String[] {"Bool"} ;
    String[] lbr_Type_rbr         = new String[] {"(", "#Type", ")"} ;
    String[] TermDecl_rule        = new String[] {"VAR", "#Args", "=", 
						  "#Exp", ";"} ;
    String[] VAR_Args             = new String[] {"VAR", "#Args"} ;
    String[] Exp1                 = new String[] {"#Exp1"} ;
    String[] if_then_else_rule    = new String[] {"if", "#Exp", "then", 
						  "#Exp", "else", "#Exp"} ;
    String[] Exp2_Op1             = new String[] {"#Exp2", "#Op1"} ;
    String[] eq_rule              = new String[] {"==", "#Exp2"} ;
    String[] lteq_le              = new String[] {"<=", "#Exp2"} ;
    String[] Exp3_Ops2            = new String[] {"#Exp3", "#Ops2"} ;
    String[] plus_rule            = new String[] {"+", "#Exp3", "#Ops2"} ;
    String[] minus_rule           = new String[] {"-", "#Exp3", "#Ops2"} ;
    String[] Exp4_Ops3            = new String[] {"#Exp4", "#Ops3"} ;
    String[] VAR                  = new String[] {"VAR"} ;
    String[] NUM                  = new String[] {"NUM"} ;
    String[] BOOLEAN              = new String[] {"BOOLEAN"} ;
    String[] lbr_Exp_rbr          = new String[] {"(", "#Exp", ")"} ;

    String[] tableEntry (String nonterm, String tokClass) {

	// ADD CODE HERE
    }

}


// For testing

class MH_ParserDemo {

    static PARSER MH_Parser = new MH_Parser() ;

    public static void main (String[] args) throws Exception {
	Reader reader = new BufferedReader (new FileReader (args[0])) ;
	LEX_TOKEN_STREAM MH_Lexer = 
	    new CheckedSymbolLexer (new MH_Lexer (reader)) ;
	TREE theTree = MH_Parser.parseTokenStream (MH_Lexer) ;
    }
}
