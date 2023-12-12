%option noyywrap

%{
    int intval = 0;
    double floatval = 0.0;
%}

%%

a {
    printf("<1>\n");
}

a*b {
   printf("<2>\n"); 
}

c {
   printf("<3>\n"); 
}

c* {
   printf("<4>\n"); 
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