
// File:   MH_Lexer.java
// Date:   October 2015

// Java template file for lexer component of Informatics 2A Assignment 1 (2015).
// Concerns lexical classes and lexer for the language MH (`Micro-Haskell').


import java.io.* ;

class MH_Lexer extends GenLexer implements LEX_TOKEN_STREAM {

static class VarAcceptor extends GenAcceptor implements DFA {
    // add code here
}

static class NumAcceptor extends GenAcceptor implements DFA {
    // add code here
}

static class BooleanAcceptor extends GenAcceptor implements DFA {
    // add code here
}

static class SymAcceptor extends GenAcceptor implements DFA {
    // add code here
}

static class WhitespaceAcceptor extends GenAcceptor implements DFA {
    // add code here
}

static class CommentAcceptor extends GenAcceptor implements DFA {
    // add code here
}

static class TokAcceptor extends GenAcceptor implements DFA {

    String tok ;
    int tokLen ;
    TokAcceptor (String tok) {this.tok = tok ; tokLen = tok.length() ;}

    // add code here
}

    // add definition of MH_acceptors here


    MH_Lexer (Reader reader) {
	super(reader,MH_acceptors) ;
    }

}
