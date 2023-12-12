%option noyywrap

DIGIT [0-9]
HEXADECIMAL [0-9a-fA-F]

%{

    void output_ipv4(char* value)
    {
        printf("IPV4:%s\n", value);
    }

    void output_ipv6(char* value)
    {
        printf("IPV6:%s\n", value);
    }

%}

%%

({DIGIT}{1,3}"."){3}{DIGIT}{1,3} {
    // extract the ipv4 adress from the string
    // format: 192.168.1.102
    output_ipv4(yytext);
}


({HEXADECIMAL}{0,4}":"){7}{HEXADECIMAL}{0,4} {
    // extract the ipv6 adress from the string
    // format: 2001:0db8:85a3:0000:0000:8a2e:0370:7334
    output_ipv6(yytext);
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

}