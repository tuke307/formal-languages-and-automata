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

#ifndef VARIABLES_H
#define VARIABLES_H


#define MAX_LENGTH_VAR 100
typedef struct _Variables
{
    char identifier[MAX_LENGTH_VAR];
    int value;    
    struct _Variables* next;
} Variables;

/* Initialize the variables struture */
void variables_reset(Variables* v);

/* Return the value of identifier in v; if it is not yet present in v,
 an entry is added and 0 is returned. */
int variable_get_value(Variables* v, char* identifier);

/* Set the value of identifier in v; if it is not yet present in v,
an entry is added and the value set.*/
void variable_set_value(Variables* v, char* identifier, int value);


#endif