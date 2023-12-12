%option noyywrap

DIGIT [0-9]

%{
#include "string.h"
#include "stdint.h"

#define YY_DECL int yylex()

#include "parser.tab.h"

%}

%%

[\n \t]+ {
    // ignore newlines, tabs and spaces
}

"(" {
    return T_LEFT_PAR;
}

")" {
    return T_RIGHT_PAR;
}

";" {
    return T_SEMICOLON;
}

"+" {
    return T_PLUS;
}

"-" {
    return T_MINUS;
}

"*" {
    return T_MUL;
}

"/" {
    return T_DIV;
}


":=" {
    return T_ASSIGN;
}

[A-Za-z][A-Za-z_0-9]* {
    yylval.var_identifier = strdup(yytext); // beware of memory leaks...
    return T_VAR_IDENT;
}

[0-9]+ {

    yylval.integer_literal = atoi(yytext);
    return T_INT_LITERAL;
}

. {
    /* leave this as last rule - it catches all non-recognizable characters.*/
    printf("invalid token found.\n");
    exit(1);
}

%%


