/*
Primitive symbol table and value storage for variables.

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


#include "variables.h"
#include "stdlib.h"
#include "string.h"


void variables_reset(Variables* v)
{
    if (v == NULL)
    {
        return; // error, actually
    }
    v->next = NULL;
    v->identifier[0] = '\0';
}

int variable_get_value(Variables* v, char* identifier)
{
    if (v == NULL)
    {
        return 0; // error, actually
    }
    if (strcmp(identifier, v->identifier) == 0)
    {
        return v->value;
    }
    else if (v->next != NULL)
    {
        return variable_get_value(v->next, identifier);
    }
    else // v->next == NULL
    {
        v->next = (Variables*)malloc(sizeof(Variables));
        strncpy(&(v->next->identifier[0]), identifier, MAX_LENGTH_VAR);
        v->next->value = 0;
        return 0;
    }
}

void variable_set_value(Variables* v, char* identifier, int value)
{
    if (v == NULL)
    {
        return; // error, actually
    }
    else if (strcmp(identifier, v->identifier) == 0)
    {
        v->value = value;
    }
    else if (v->next != NULL)
    {
        variable_set_value(v->next, identifier, value);
    }
    else // v->next == NULL
    {
        v->next = (Variables*)malloc(sizeof(Variables));
        strncpy(&(v->next->identifier[0]), identifier, MAX_LENGTH_VAR);
        v->next->value = value;
    }
}
