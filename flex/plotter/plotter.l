%option noyywrap

DIGIT [0-9]

%{
#include "string.h"
#include "stdint.h"

#define CANVAS_SIZE 50

char canvas[CANVAS_SIZE][CANVAS_SIZE];
int32_t x = 0;
int32_t y = CANVAS_SIZE-1;


// set all canvas points to "."
void reset_canvas()
{
    memset(&canvas[0], '.', sizeof(canvas));
}

void draw_canvas()
{
    for (int32_t py = 0; py < CANVAS_SIZE; ++py)
    {
        for (int32_t px = 0; px < CANVAS_SIZE; px++)
        {
            if (px == x && py == y)
            {
                printf("*");
            }
            else
            {
                printf("%c", canvas[px][py]);
            }
        }
        printf("\n");
    }
}

/* Moves horizontal cursor position to x + offset if
   it represents a valid position between 0 and CANVAS_SIZE.
   If plot is != 0, "X" is plotted on all visited points. */
void move_x(int32_t offset, int32_t plot)
{
    int32_t new_x = x + offset;
 
    if (new_x < 0 || new_x >= CANVAS_SIZE)
    {
        return;
    }
    while (x != new_x)
    {
        if (plot)
        {
            canvas[x][y] = 'X';
        }
        x += (offset < 0) ? -1 : 1;
    }
}

/* Moves horizontal cursor position to x + offset if
   it represents a valid position between 0 and CANVAS_SIZE.
   If plot is != 0, "X" is plotted on all visited points. */
void move_y(int32_t offset, int32_t plot)
{
    int32_t new_y = y + offset;
    if (new_y < 0 || new_y >= CANVAS_SIZE)
    {
        return;
    }
    while (y != new_y)
    {
        if (plot)
        {
            canvas[x][y] = 'X';
        }
        y += (offset < 0) ? -1 : 1;
    }
}


%}

%%

"ADD RULES FOR MOVE OPERATIONS HERE" {
    
}

S {
    draw_canvas();
}

Q {
    exit(0);
}

[ \n\t\r]+ {
    /* Skip whitespaces */
}

.* {
    printf("Unknown command: %s\n", yytext);
}

%%

// Example for a possible plotting image
void example_plot()
{

    move_y(-40, 1);
    move_x(40, 1);
    move_y(40, 1);
    move_x(-40, 1);
    move_x(10, 0);
    move_y(-30, 0);
    move_x(20, 1);
    move_y(20, 1);
    move_x(-20, 1);
    move_y(-20, 1);
    draw_canvas();
}


int main( int argc, char **argv )
{
    reset_canvas();
    
    // example_plot();
    
    ++argv, --argc; /* skip over program name */
    if ( argc > 0 )
    {
        yyin = fopen( argv[0], "r" );
    }
    else
    {
        yyin = stdin;
    }
    reset_canvas();
    yylex();
}
