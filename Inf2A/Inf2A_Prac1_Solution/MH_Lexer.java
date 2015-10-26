/**
 * File:   MH_Lexer.java
 * Date:   October 2014
 *
 * Java template file for lexer component of Informatics 2A Assignment 1 (2014).
 * Concerns lexical classes and lexer for the language MH (`Micro-Haskell').
 */

import java.io.* ;

class VarAcceptor extends GenAcceptor {
    public String lexClass() {
        return "VAR";
    }

    public int totalStates() {
        return 4;
    }

    public int nextState(char c, int state) {
        switch (state) {
            case 0:
                if (Character.lowerCase(c)) {
                    return 1;
                } else {
                    return 3;
                }
            case 1:
                if (Character.lowerCase(c) || Character.upperCase(c) ||
                    Character.digit(c)) {
                    return 1;
                } else if (c == '\'') {
                    return 2;
                } else {
                    return 3;
                }
            case 2:
                if (c == '\'') {
                    return 2;
                } else {
                    return 3; 
                }
            default:
                return 3; // dead state
        }
    }

    public boolean isGoalState(int state) {
        return (state == 1 || state == 2);
    }

    public boolean isDeadState(int state) {
        return (state == 3);
    }
}

class NumAcceptor extends GenAcceptor {
    public String lexClass() {
        return "NUM";
    }

    public int totalStates() {
        return 4;
    }

    public int nextState(char c, int state) {
        if (!Character.digit(c)) { // the character is not a digit, "dead state"
            return 3;
        }

        switch (state) {
            case 0:
                if (c == '0') {
                    return 1;
                } else {
                    return 2;
                }
            case 1:
                return 3; 
            case 2:
                return 2;
            default:
                return 3; // dead state
        }
    }

    public boolean isGoalState(int state) {
        return (state == 1 || state == 2);
    }

    public boolean isDeadState(int state) {
        return (state == 3);
    }
}

class BooleanAcceptor extends GenAcceptor {
    public String lexClass() {
        return "BOOLEAN";
    }

    public int totalStates() {
        return 10;
    }

    public int nextState(char c, int state) {
        switch (state) {
            case 0:
                if (c == 'T') return 1;
                else if (c == 'F') return 4;
                else return 9;
            case 1:
                if (c == 'r') return 2;
                else return 9;
            case 2:
                if (c == 'u') return 3;
                else return 9;
            case 3:
                if (c == 'e') return 8;
                else return 9;
            case 4:
                if (c == 'a') return 5;
                else return 9;
            case 5:
                if (c == 'l') return 6;
                else return 9;
            case 6:
                if (c == 's') return 7;
                else return 9;
            case 7:
                if (c == 'e') return 8;
                else return 9;
            case 8:
                return 9;
            default:
                return 9;
        } 
    }

    public boolean isGoalState(int state) {
        return (state == 8);
    }

    public boolean isDeadState(int state) {
        return (state == 9);
    }
}

class SymAcceptor extends GenAcceptor {
    public String lexClass() {
        return "SYM";
    }

    public int totalStates() {
        return 3;
    }

    public int nextState(char c, int state) {
        switch (state) {
            case 0:
            case 1:
                if (Character.symbol(c)) {
                    return 1;
                } else {
                    return 2;
                }
            default:
                return 2; // dead state
        }
    }

    public boolean isGoalState(int state) {
        return (state == 1);
    }

    public boolean isDeadState(int state) {
        return (state == 2);
    }
}

class WhitespaceAcceptor extends GenAcceptor {
    public String lexClass() {
        return "";
    }

    public int totalStates() {
        return 3;
    }

    public int nextState(char c, int state) {
        switch (state) {
            case 0:
            case 1:
                if (Character.whitespace(c)) {
                    return 1;
                } else {
                    return 2;
                }
            default:
                return 2; // dead state
        }
    }

    public boolean isGoalState(int state) {
        return (state == 1);
    }

    boolean isDeadState(int state) {
        return (state == 2);
    }
}

class CommentAcceptor extends GenAcceptor {
    public String lexClass() {
        return "";
    }

    public int totalStates() {
        return 6;
    }

    public int nextState(char c, int state) {
        switch (state) {
            case 0:
                if (c == '-') return 1;
                else return 5;
            case 1:
                if (c == '-') return 2;
                else return 5;
            case 2:
                if (!Character.symbol(c) && !Character.newline(c)) return 3;
                else if (c == '-') return 4;
                else return 5;
            case 3:
                if (!Character.newline(c)) return 3;
                else return 5;
            case 4:
                if (c == '-') return 4;
                else return 5;
            default:
                return 5; // dead state
        }
    }

    public boolean isGoalState(int state) {
        return (state == 2 || state == 3 || state == 4);
    }

    public boolean isDeadState(int state) {
        return (state == 5);
    }
}

class TokAcceptor extends GenAcceptor {
    String tok;
    int tokLen;

    TokAcceptor (String tok) {
        this.tok = tok;
        tokLen = tok.length();
    }

    public String lexClass() {
        return tok;
    }

    public int totalStates() {
        return tokLen + 2;
    }

    /**
     * State number records number of string characters processed.
     * tokLen+1 is dead state
     */
    public int nextState(char c, int state) {
        if (state < tokLen && c == tok.charAt(state)) {
            return (state + 1);
        } else {
            return tokLen + 1;
        }
    }
	
    public boolean isGoalState(int state) {
        return (state == tokLen);
    }

    public boolean isDeadState(int state) {
        return (state == tokLen + 1);
    }
}


public class MH_Lexer extends GenLexer implements LEX_TOKEN_STREAM {
    static DFA varAcc = new VarAcceptor();
    static DFA numAcc = new NumAcceptor();
    static DFA booleanAcc = new BooleanAcceptor();
    static DFA symAcc = new SymAcceptor();
    static DFA whitespaceAcc = new WhitespaceAcceptor();
    static DFA commentAcc = new CommentAcceptor();

    static DFA IntegerAcc = new TokAcceptor("Integer");
    static DFA BoolAcc = new TokAcceptor("Bool");
    static DFA ifAcc = new TokAcceptor("if");
    static DFA thenAcc = new TokAcceptor("then");
    static DFA elseAcc = new TokAcceptor("else");

    static DFA lbrAcc = new TokAcceptor("(");
    static DFA rbrAcc = new TokAcceptor(")");
    static DFA semiAcc = new TokAcceptor(";");

    static DFA[] MH_acceptors = new DFA[] {
        IntegerAcc, BoolAcc, ifAcc, thenAcc, elseAcc,
        lbrAcc, rbrAcc, semiAcc, 
        varAcc, numAcc, booleanAcc, 
        whitespaceAcc, commentAcc, symAcc
    };

    MH_Lexer (Reader reader) {
        super(reader, MH_acceptors);
    }

}

