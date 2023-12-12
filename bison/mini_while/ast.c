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


#include "ast.h"
#include "stdlib.h"
#include "stdio.h"


AST* ast_make(yytoken_kind_t type, int value, char* identifier)
{
    AST* result = (AST*)calloc(1, sizeof(AST));
    result->type = type;
    result->int_value = value;
    result->identifier = identifier;
    return result;
}

AST* ast_create(yytoken_kind_t type)
{
    return ast_make(type, 0, NULL);
}

void ast_set_child(AST* ast, unsigned index, AST* child_ast)
{
    ast->children[index] = child_ast;
}

AST* ast_get_child(AST* ast, unsigned index)
{
    return ast->children[index];
}

Eval_Result ast_eval(AST* ast, Variables* variables)
{
    Eval_Result result = {0, NULL};
    AST* left = NULL;
    AST* right = NULL;
    yytoken_kind_t ast_type = (yytoken_kind_t)ast->type;
    switch(ast_type)
    {
        case T_SEMICOLON:
        {
            left = ast_get_child(ast, 0);
            right = ast_get_child(ast, 1);
            result = ast_eval(left, variables);
            if (right != NULL)
            {
                result = ast_eval(right, variables);
            }
            break;
        }
        case T_INT_LITERAL:
        {
            result.int_value = ast->int_value;
            break;
        }
        case T_ASSIGN:
        {
            left = ast_get_child(ast, 0);
            right = ast_get_child(ast, 1);
            variable_set_value(variables, ast_eval(left, variables).identifier, ast_eval(right, variables).int_value);
            break;
        }
        case T_VAR_IDENT:
        {
            result.int_value = variable_get_value(variables, ast->identifier);
            result.identifier = ast->identifier;
            break;
        }
        case T_PLUS:
        case T_MINUS:
        case T_MUL:
        case T_DIV:
        case T_EQ:
        case T_NEQ:
        case T_LESS:
        {
            left = ast_get_child(ast, 0);
            right = ast_get_child(ast, 1);
            int left_val = ast_eval(left, variables).int_value;
            int right_val = ast_eval(right, variables).int_value;
            if (ast_type == T_PLUS)
            {
                result.int_value = left_val + right_val;
            }
            else if (ast_type == T_MINUS)
            {
                result.int_value = left_val - right_val;
            }
            else if (ast_type == T_MUL)
            {
                result.int_value = left_val * right_val;
            }
            else if (ast_type == T_DIV)
            {
                result.int_value = left_val / right_val;
            }
            else if (ast_type == T_EQ)
            {
                result.int_value = left_val == right_val;
            }
            else if (ast_type == T_NEQ)
            {
                result.int_value = left_val != right_val;
            }
            else if (ast_type == T_LESS)
            {
                result.int_value = left_val < right_val;
            }
            break;
        }
        case T_SKIP:
        {
            break;
        }
        case T_IF:
        {
            /*
            first child: condition;
            second child: then branch; third child: else branch
            */
            AST* cond = ast_get_child(ast, 0);
            int cond_val = ast_eval(cond, variables).int_value;
            if (cond_val != 0)
            {
                result = ast_eval(ast_get_child(ast, 1), variables);
            }
            else
            {
                result = ast_eval(ast_get_child(ast, 2), variables);
            }
            break;
        }
        case T_WHILE:
        {
            /*
            first child: condition; 
            second child: loop entry branch; third child: loop exit branch
            */
            AST* cond = ast_get_child(ast, 0);
            int cond_val = ast_eval(cond, variables).int_value;
            while (cond_val != 0)
            {
                result = ast_eval(ast_get_child(ast, 1), variables);
                // variables have potentially changed, evaluate condition again
                cond_val = ast_eval(cond, variables).int_value;
            }
            break;
        }
        default:
            break;
    }
    return result;
}

static void print_spaces(int indent)
{
    for (int i = 0; i < indent; ++i)
    {
        printf(" ");
    }
}

void ast_print(AST* ast, int indent)
{
    printf("\n");
    print_spaces(indent);
    if (ast == NULL)
    {
        return;
    }
    indent += 2;
    yytoken_kind_t ast_type = (yytoken_kind_t)ast->type;
    AST* left;
    AST* right;

    switch(ast_type)
    {
        case T_SEMICOLON:
        {
            left = ast_get_child(ast, 0);
            right = ast_get_child(ast, 1);
            printf("<SEQUENCE>");
            ast_print(left, indent);
            ast_print(right, indent);
            break;
        }
        case T_INT_LITERAL:
        {
            printf("<INT:%d>", ast->int_value);
            break;
        }
        case T_ASSIGN:
        {
            left = ast_get_child(ast, 0);
            right = ast_get_child(ast, 1);
            printf("<ASSIGN>");
            ast_print(left, indent);
            ast_print(right, indent);
            break;
        }
        case T_VAR_IDENT:
        {
            printf("<VAR:%s>", ast->identifier);
            break;
        }
        case T_PLUS:
        case T_MINUS:
        case T_MUL:
        case T_DIV:
        case T_EQ:
        case T_NEQ:
        case T_LESS:
        {
            left = ast_get_child(ast, 0);
            right = ast_get_child(ast, 1);
            printf("<OP>");
            ast_print(left, indent);
            ast_print(right, indent);
            break;
        }
        case T_SKIP:
        {
            printf("<SKIP>");
            break;
        }
        case T_IF:
        {
            AST* cond = ast_get_child(ast, 0);
            AST* then_branch = ast_get_child(ast, 1);
            AST* else_branch = ast_get_child(ast, 2);
            right = ast_get_child(ast, 1);
            printf("<IF>");
            ast_print(cond, indent);
            ast_print(then_branch, indent);
            ast_print(else_branch, indent);
            break;
        }
        case T_WHILE:
        {
            AST* cond = ast_get_child(ast, 0);
            AST* do_branch = ast_get_child(ast, 1); 
            printf("<WHILE>");
            ast_print(cond, indent);
            ast_print(do_branch, indent);
            break;
        }
        default:
            break;
    }
}