
// File:   MH_Lexer.java
// Date:   October 2015

// Java template file for lexer component of Informatics 2A Assignment 1 (2015).
// Concerns lexical classes and lexer for the language MH (`Micro-Haskell').


import java.io.* ;

class MH_Lexer extends GenLexer implements LEX_TOKEN_STREAM {

static class VarAcceptor extends GenAcceptor implements DFA {
    // add code here
	  public String lexClass() {return "VAR" ;} ;
	    public int numberOfStates() {return 3 ;} ;

	    int nextState (int state, char c) {
		switch (state) {
		case 0: if (CharTypes.isSmall(c)) return 1 ; else return 2 ;
		case 1: if (CharTypes.isSmall(c)||CharTypes.isLarge(c)||c=='\'') return 1 ; else return 2 ;
		default: return 2 ;
		}
	    }
	    boolean accepting (int state) {return (state == 1) ;}
	    boolean dead (int state) {return (state == 2) ;}
}

static class NumAcceptor extends GenAcceptor implements DFA {
    // add code here
	 public String lexClass() {return "NUM" ;} ;
	    public int numberOfStates() {return 3 ;} ;

	    int nextState (int state, char c) {
		switch (state) {
		case 0: if (CharTypes.isDigit(c)) return 1 ; else return 2 ;
		case 1: if (CharTypes.isDigit(c)) return 1 ; else return 2 ;
		default: return 2 ;
		}
	    }
	    boolean accepting (int state) {return (state == 1) ;}
	    boolean dead (int state) {return (state == 2) ;}
}

static class BooleanAcceptor extends GenAcceptor implements DFA {
    // add code here
	public String lexClass() {return "BOOLEAN" ;} ;
    public int numberOfStates() {return 11 ;} ;
    int nextState (int state, char c) {
    	switch(state){
    case 0: if (c=='T') return 1 ; else if(c=='F') return 5 ; else return 10;
	case 1: if (c=='r') return 2 ; else return 10;
	case 2: if (c=='u') return 3 ; else return 10;
	case 3: if (c=='e') return 4 ; else return 10;
	case 5: if (c=='a') return 6 ; else return 10;
	case 6: if (c=='l') return 7 ; else return 10;
	case 7: if (c=='s') return 8 ; else return 10;
	case 8: if (c=='e') return 9 ; else return 10;
	default: return 10; }
    }
    boolean accepting (int state) {return (state==4)||(state==9);}
    boolean dead (int state) {return (state==10) ;}
}

static class SymAcceptor extends GenAcceptor implements DFA {
    // add code here
	public String lexClass() {return "SYM" ;} ;
    public int numberOfStates() {return 3 ;} ;

    int nextState (int state, char c) {
	switch (state) {
	case 0: if (CharTypes.isSymbolic(c)) return 1 ; else return 2 ;
	case 1: if (CharTypes.isSymbolic(c)) return 1 ; else return 2 ;
	default: return 2 ;
	}
    }
    boolean accepting (int state) {return (state == 1) ;}
    boolean dead (int state) {return (state == 2) ;}
}

static class WhitespaceAcceptor extends GenAcceptor implements DFA {
    // add code here
	public String lexClass() {return "" ;} ;
    public int numberOfStates() {return 3 ;} ;

    int nextState (int state, char c) {
	switch (state) {
	case 0: if (CharTypes.isWhitespace(c)) return 1 ; else return 2 ;
	case 1: if (CharTypes.isWhitespace(c)) return 1 ; else return 2 ;
	default: return 2 ;
	}
    }
    boolean accepting (int state) {return (state == 1) ;}
    boolean dead (int state) {return (state == 2) ;}
}

static class CommentAcceptor extends GenAcceptor implements DFA {
    // add code here
	public String lexClass() {return "" ;} ;
    public int numberOfStates() {return 5 ;} ;

    int nextState (int state, char c) {
	switch (state) {
	case 0: if (c=='-') return 1 ; else return 4 ;
	case 1: if (c=='-') return 2 ; else return 4 ;
	case 2: if (c=='-') return 2; else if(!CharTypes.isSymbolic(c)&&!CharTypes.isNewline(c)) return 3; else return 4;
	case 3: if(!CharTypes.isNewline(c)) return 3; else return 4;
	default: return 4 ;
	}
    }
    boolean accepting (int state) {return (state == 2||state==3) ;}
    boolean dead (int state) {return (state==4) ;}
}
static class IntegerAcceptor extends GenAcceptor implements DFA {
    // add code here
	TokAcceptor tA=new TokAcceptor("Integer");
	public String lexClass() {return tA.tok ;} ;
    public int numberOfStates() {return  tA.tokLen+2 ;} ;
    int nextState (int state, char c) {
	return tA.nextState(state, c);
    }
    boolean accepting (int state) {return tA.accepting(state);}
    boolean dead (int state) {return tA.dead(state) ;}
}
static class BoolAcceptor extends GenAcceptor implements DFA {
    // add code here
	TokAcceptor tA=new TokAcceptor("Bool");
	public String lexClass() {return tA.tok ;} ;
    public int numberOfStates() {return  tA.tokLen+2 ;} ;
    int nextState (int state, char c) {
	return tA.nextState(state, c);
    }
    boolean accepting (int state) {return tA.accepting(state);}
    boolean dead (int state) {return tA.dead(state) ;}
}
static class IfAcceptor extends GenAcceptor implements DFA {
    // add code here
	TokAcceptor tA=new TokAcceptor("if");
	public String lexClass() {return tA.tok ;} ;
    public int numberOfStates() {return  tA.tokLen+2 ;} ;
    int nextState (int state, char c) {
	return tA.nextState(state, c);
    }
    boolean accepting (int state) {return tA.accepting(state);}
    boolean dead (int state) {return tA.dead(state) ;}
}
static class ThenAcceptor extends GenAcceptor implements DFA {
    // add code here
	TokAcceptor tA=new TokAcceptor("then");
	public String lexClass() {return tA.tok ;} ;
    public int numberOfStates() {return  tA.tokLen+2 ;} ;
    int nextState (int state, char c) {
	return tA.nextState(state, c);
    }
    boolean accepting (int state) {return tA.accepting(state);}
    boolean dead (int state) {return tA.dead(state) ;}
}
static class ElseAcceptor extends GenAcceptor implements DFA {
    // add code here
	TokAcceptor tA=new TokAcceptor("else");
	public String lexClass() {return tA.tok ;} ;
    public int numberOfStates() {return  tA.tokLen+2 ;} ;
    int nextState (int state, char c) {
	return tA.nextState(state, c);
    }
    boolean accepting (int state) {return tA.accepting(state);}
    boolean dead (int state) {return tA.dead(state) ;}
}
static class OpenBracketAcceptor extends GenAcceptor implements DFA {
    // add code here
	TokAcceptor tA=new TokAcceptor("(");
	public String lexClass() {return tA.tok ;} ;
    public int numberOfStates() {return  tA.tokLen+2 ;} ;
    int nextState (int state, char c) {
	return tA.nextState(state, c);
    }
    boolean accepting (int state) {return tA.accepting(state);}
    boolean dead (int state) {return tA.dead(state) ;}
}
static class ClosedBracketAcceptor extends GenAcceptor implements DFA {
    // add code here
	TokAcceptor tA=new TokAcceptor(")");
	public String lexClass() {return tA.tok ;} ;
    public int numberOfStates() {return  tA.tokLen+2 ;} ;
    int nextState (int state, char c) {
	return tA.nextState(state, c);
    }
    boolean accepting (int state) {return tA.accepting(state);}
    boolean dead (int state) {return tA.dead(state) ;}
}
static class SemicolonAcceptor extends GenAcceptor implements DFA {
    // add code here
	TokAcceptor tA=new TokAcceptor(";");
	public String lexClass() {return tA.tok ;} ;
    public int numberOfStates() {return  tA.tokLen+2 ;} ;
    int nextState (int state, char c) {
	return tA.nextState(state, c);
    }
    boolean accepting (int state) {return tA.accepting(state);}
    boolean dead (int state) {return tA.dead(state) ;}
}
static class TokAcceptor extends GenAcceptor implements DFA {
    // add code here
    String tok ;
    int tokLen ;
    TokAcceptor (String tok) {this.tok = tok ; tokLen = tok.length() ;}
    public String lexClass() {return tok ;} ;
    public int numberOfStates() {return tokLen+2;} ;

    int nextState (int state, char c) {
    if(state>=tokLen) return tokLen+1; 
    else if (c==tok.charAt(state)) return state+1 ; 
    else return tokLen+1 ;
	
	}
    boolean accepting (int state) {return (state == tokLen) ;}
    boolean dead (int state) {return (state == tokLen+1) ;}
     
}


    // add definition of MH_acceptors here
     static VarAcceptor varAcceptor=new VarAcceptor();
   static NumAcceptor numAcceptor=new NumAcceptor();
   static BooleanAcceptor booleanAcceptor=new BooleanAcceptor();
   static SymAcceptor symAcceptor=new SymAcceptor();
   static WhitespaceAcceptor whitespaceAcceptor=new WhitespaceAcceptor();
   static CommentAcceptor commentAcceptor=new CommentAcceptor();
   static IntegerAcceptor integerAcceptor=new IntegerAcceptor();
   static BoolAcceptor boolAcceptor=new BoolAcceptor();
   static IfAcceptor ifAcceptor=new IfAcceptor();
   static ThenAcceptor thenAcceptor=new ThenAcceptor();
   static ElseAcceptor elseAcceptor=new ElseAcceptor();
   static OpenBracketAcceptor openBracketAcceptor=new OpenBracketAcceptor();
   static ClosedBracketAcceptor closedBracketAcceptor=new ClosedBracketAcceptor();
   static SemicolonAcceptor semicolonAcceptor=new SemicolonAcceptor();
   static DFA[] MH_acceptors=new DFA[]  {commentAcceptor,ifAcceptor,thenAcceptor,elseAcceptor,boolAcceptor,integerAcceptor,openBracketAcceptor,closedBracketAcceptor,
	   semicolonAcceptor,varAcceptor, numAcceptor, booleanAcceptor, symAcceptor, whitespaceAcceptor};

    MH_Lexer (Reader reader) {
	super(reader,MH_acceptors) ;
    }

}
