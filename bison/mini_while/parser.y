%{

#include <stdio.h>
#include <stdlib.h>
#include "variables.h"
#include "ast.h"

extern int yylex();
extern int yyparse();
extern FILE* yyin;

Variables v;

typedef struct _AST AST;

int yyerror(const char* s);

%}

%union {
	AST* ast;
    char* var_identifier;
    int int_val;
}

%token<int_val> T_INT_LITERAL
%token<var_identifier> T_VAR_IDENT
%token T_ASSIGN 
%token T_LEFT_PAR T_RIGHT_PAR T_SEMICOLON
%token T_PLUS T_MUL T_MINUS T_DIV T_EQ T_LESS T_NEQ
%token T_WHILE T_DO T_OD T_IF T_THEN T_ELSE T_FI T_SKIP T_END
%type<ast> prog stmt stmts expr add term factor assign if skip ident while
%start prog

%%

prog: stmts T_END {
     $$ = $1; 
     ast_eval($$, &v);
     ast_print($$, 0);
     printf("\nresult=%d\n", variable_get_value(&v, "result")); }

stmts:
    %empty { $$ = NULL;}
    | stmt T_SEMICOLON stmts {
         if ($3 != NULL)
         {
            $$ = ast_create(T_SEMICOLON); ast_set_child($$, 0, $1);  ast_set_child($$, 1, $3);
         }
         else
         {
            $$ = $1;
         }
    }
    | error T_SEMICOLON stmts { printf("Parse error.\n");};
    
stmt: assign { $$ = $1;}
    | expr { $$ = $1;}
    | if {$$ = $1;}
    | skip {$$ = $1;}

skip: T_SKIP { $$ = ast_create(T_SKIP); }

assign: ident T_ASSIGN expr 
{ 
    $$ = ast_create(T_ASSIGN);
    ast_set_child($$, 0, $1); 
    ast_set_child($$, 1, $3);
}

expr:
    expr T_EQ add {    
        $$ = ast_create(T_EQ);
        ast_set_child($$, 0, $1); 
        ast_set_child($$, 1, $3);
    }
    | expr T_LESS add {    
        $$ = ast_create(T_LESS);
        ast_set_child($$, 0, $1); 
        ast_set_child($$, 1, $3);
    }
    | expr T_NEQ add {    
        $$ = ast_create(T_NEQ);
        ast_set_child($$, 0, $1); 
        ast_set_child($$, 1, $3);
    }
    | add
    {
        $$ = $1;
    }

add: 
    add T_PLUS term {
        $$ = ast_create(T_PLUS);
        ast_set_child($$, 0, $1); 
        ast_set_child($$, 1, $3);
    }
    | add T_MINUS term {
        $$ = ast_create(T_MINUS);
        ast_set_child($$, 0, $1); 
        ast_set_child($$, 1, $3);
    }
    | term { $$ = $1; }

term: term T_MUL factor {
        $$ = ast_create(T_MUL);
        ast_set_child($$, 0, $1); 
        ast_set_child($$, 1, $3);
    }
    | term T_DIV factor {
    $$ = ast_create(T_DIV);
    ast_set_child($$, 0, $1); 
    ast_set_child($$, 1, $3);
    }
    | factor { $$ = $1;}

factor: ident { $$ = $1; }
        | T_INT_LITERAL {  $$ = ast_make(T_INT_LITERAL, $1, NULL);}
        | T_LEFT_PAR expr T_RIGHT_PAR { $$ = $2;}
        | T_MINUS T_INT_LITERAL { $$ = ast_make(T_INT_LITERAL, -$2, NULL);}

ident: T_VAR_IDENT
{
    $$ = ast_make(T_VAR_IDENT, 0, variable_get_ident(&v, $1));
}

if: T_IF expr T_THEN stmts T_ELSE stmts T_FI 
{ 
    $$ = ast_create(T_IF); ast_set_child($$, 0, $2); ast_set_child($$, 1, $4); ast_set_child($$, 2, $6); 
}

while: T_WHILE expr T_DO stmts T_OD
{
    $$ = ast_create(T_WHILE); ast_set_child($$, 0, $2); ast_set_child($$, 1, $4);
}

%%

int yyerror(const char* s) 
{
	fprintf(stderr, "Parse error: %s\n", s);
	exit(1);
}

int main(int argc, char **argv)
{
    variables_reset(&v);

    ++argv, --argc; /* skip over program name */
    if ( argc > 0 )
    {
        yyin = fopen( argv[0], "r" );
        if (argc > 1)
        {
            // add a possible input
            variable_set_value(&v, "input", atoi(argv[1]));
        }
    }
    else
    {
        yyin = stdin;
    }
    return yyparse();
}
