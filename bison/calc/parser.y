%{

#include <stdio.h>
#include <stdlib.h>
#include "variables.h"

extern int yylex();
extern int yyparse();
extern FILE* yyin;

Variables variables;

int yyerror(const char* s);
%}

%union {
	int integer_literal;
	char* var_identifier;
}

%token<integer_literal> T_INT_LITERAL
%token<var_identifier> T_VAR_IDENT
%token T_ASSIGN
%token T_LEFT_PAR T_RIGHT_PAR T_SEMICOLON
%token T_PLUS T_MUL T_MINUS T_DIV
%type<integer_literal> stmt stmts expr term factor assign
%start stmts // start symbol

%%

stmts:
    %empty {}
    | stmt T_SEMICOLON stmts {}
    | error T_SEMICOLON stmts { printf("Parse error.\n");};
    
stmt: assign { printf("%i\n", $1); $$ = $1;}
    | expr { printf("%i\n", $1); $$ = $1;}

assign: T_VAR_IDENT T_ASSIGN expr { variable_set_value(&variables, $1, $3); $$ = $3; }

expr: expr T_PLUS term { $$ = $1 + $3;}
    | expr T_MINUS term { $$ = $1 - $3;} // Subtraction rule
    | term {  $$ = $1;}

term: term T_MUL factor { $$ = $1 * $3;}
    | term T_DIV factor { $$ = $1 / $3;} // Division rule
    | factor { $$ = $1;}

factor: T_VAR_IDENT { $$ = variable_get_value(&variables, $1);}
    | T_INT_LITERAL {  $$ = $1;}
    | T_MINUS factor { $$ = -$2;}  // Unary minus rule
    | T_LEFT_PAR expr T_RIGHT_PAR { $$ = $2;}

%%

int yyerror(const char* s) 
{
	fprintf(stderr, "Parse error: %s\n", s);
	return 0;
}

int main() 
{
    variables_reset(&variables);
	yyin = stdin;
    return yyparse();
}

