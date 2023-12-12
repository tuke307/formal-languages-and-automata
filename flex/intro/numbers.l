%option noyywrap

DIGIT [0-9]

%{
    int intval = 0;
    double floatval = 0.0;
%}

%%

{DIGIT}+ {
    printf("int: %d (\"%s\")\n", atoi(yytext), yytext);
    intval += atoi(yytext);
}

{DIGIT}+"."{DIGIT}* {
    printf("float: %f (\"%s\")\n", atof(yytext), yytext);
    floatval += atof(yytext);
}

reset {
    intval = 0;
    floatval = 0;
    printf("Reset\n");
}

print {
    printf("Current: %d : %f\n", intval, floatval);
}

total {
    // adds the integer sum to the floating point sum and sets the total sum to 0
    floatval += intval;
    intval = 0;
    printf("Total: %f\n", floatval);
}

quit {
    exit(0);
}

\n|. {
/* Skip */
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
    printf("Final %d : %f\n", intval, floatval);
}