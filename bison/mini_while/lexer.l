%option noyywrap

%{
#include "string.h"
#include "stdint.h"

#define YY_DECL int yylex()
#include "ast.h"
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

"<" {
    return T_LESS;
}

"==" {
    return T_EQ;
}

"!=" {
    return T_NEQ;
}

"if" {
    return T_IF;
}

"then" {
    return T_THEN;
}

"else" {
    return T_ELSE;
}

"fi" {
    return T_FI;
}

"skip" {
    return T_SKIP;
}

":=" {
    return T_ASSIGN;
}

"end" {
    return T_END;
}

"while" {
    return T_WHILE;
}

[A-Za-z][A-Za-z_0-9]* {
    yylval.var_identifier = strdup(yytext); // beware of memory leaks...
    return T_VAR_IDENT;
}

[0-9]+ {

    yylval.int_val = atoi(yytext);
    return T_INT_LITERAL;
}

#[^\n]*\n {
    // comments
}

. {
    /* leave this as last rule - it catches all non-recognizable characters.*/
    printf("invalid token found.\n");
    exit(1);
}

%%


