/*
Primitive AST.

Copyright 2023, Andreas Gaiser, gaiseras@gmail.com

The above copyright notice and this permission notice shall be 
included in all copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED “AS IS”, WITHOUT WARRANTY OF ANY KIND, 
EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES 
OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND 
NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS 
BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN 
ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN 
CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.
*/

#ifndef AST_H
#define AST_H

#include "variables.h"

typedef struct _AST
{
    int type;
    int int_value;
    char* identifier;
    struct _AST* children[3]; // maximal 3 children (for if / while)
} AST;


#include "parser.tab.h"


typedef struct 
{
    int int_value;
    char* identifier;
} Eval_Result;

/* Make a new AST node, values initialized with 0 / NULL. */
AST* ast_create(yytoken_kind_t type);

/* Make a new AST node; you can provide an int_value or identifier 
(pass 0 / NULL if not required) */
AST* ast_make(yytoken_kind_t type, int int_value, char* identifier);

/* Set index-th child node of ast to child_ast. */
void ast_set_child(AST* ast, unsigned index, AST* child_ast);

/* Get index-th child node of ast. */
AST* ast_get_child(AST* ast, unsigned child);

Eval_Result ast_eval(AST* ast, Variables* variable);

void ast_print(AST* ast, int indent);

#endif