%option noyywrap

DIGIT [0-9]
LETTER [a-zA-Z_]

%{
#include "string.h"
#include "stdint.h"

// X := Y + 10;


typedef enum
{
    ASSIGN = 0, // ':='

    IF,
    THEN,
    ELSE,
    FI,
    WHILE,
    DO,
    OD,
    
    VAR_IDENTIFIER,
    INTEGER_LITERAL, 
    
    LEFT_PAR,  // '('
    RIGHT_PAR, // ')'
    SEMICOLON, // ';'

    PLUS, // '+'
    MINUS, // '-'
   
    EQUAL, // '='
    LESS, // '<'
    NOT_EQUAL, // '!='  

} Token_Kind;

const char* token_description[] = 
{
    "ASSIGN", 
    "IF", 
    "THEN",
    "ELSE",
    "FI",
    "WHILE",
    "DO",
    "OD",
    "VAR_IDENTIFIER",
    "INTEGER_LITERAL", 
    "LEFT_PAR",
    "RIGHT_PAR", 
    "SEMICOLON",
    "PLUS",
    "MINUS",
    "EQUAL",
    "LESS",
    "NOT_EQUAL"  
};


void add_token(Token_Kind kind, char* value)
{
    // later we will extend this function; currently 
    // it only outputs the token kind.
    printf("[%s]\n", token_description[kind]);
}

%}

%%

[\n \t]+ {
    // ignore newlines, tabs and spaces
}

"if" {
    add_token(IF, yytext);
}

"then" {
    add_token(THEN, yytext);
}

"else" {
    add_token(ELSE, yytext);
}

"fi" {
    add_token(FI, yytext);
}

"while" {
    add_token(WHILE, yytext);
}

"do" {
    add_token(DO, yytext);
}

"od" {
    add_token(OD, yytext);
}

"(" {
    add_token(LEFT_PAR, yytext);
}

")" {
    add_token(RIGHT_PAR, yytext);
}

";" {
    add_token(SEMICOLON, yytext);
}

"+" {
    add_token(PLUS, yytext);
}

"-" {
    add_token(MINUS, yytext);
}

"==" {
    add_token(EQUAL, yytext);
}

"<" {
    add_token(LESS, yytext);
}

"!=" {
    add_token(NOT_EQUAL, yytext);
}

":=" {
    add_token(ASSIGN, yytext);
}

{LETTER}{1}({LETTER}|{DIGIT})?+ {
    add_token(VAR_IDENTIFIER, yytext);
}

("+"|"-")?{DIGIT}+ {
    add_token(INTEGER_LITERAL, yytext);
}

. {
    /* leave this as last rule - it catches all non-recognizable characters.*/
    printf("invalid token found.\n");
    exit(1);
}

%%


int main( int argc, char **argv )
{
    
    ++argv, --argc; /* skip over program name */
    if ( argc > 0 )
    {
        yyin = fopen( argv[0], "r" );
    }
    else
    {
        yyin = stdin;
    }
    yylex();
}
