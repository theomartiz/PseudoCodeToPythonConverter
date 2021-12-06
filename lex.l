%{
#include <stdlib.h>
#include "y.tab.h"
%}

%%
  
: printf("DECLARATOR,");
:=  printf("ASSIGNATOR,");
" " printf("SEPARATOR,");
var printf("VAR,");
string printf("STRING,");
char printf("CHAR,");
int printf("INT,");
real printf("REAL,");
boolean printf("BOOLEAN,");
div printf("DIV,");
mod printf("MOD,");
and printf("AND,");
or printf("OR,");
not printf("NOT,");
abs printf("ABS,");
log printf("LOG,");
exp printf("EXP,");
beg printf("BEG,");
end printf("END,");
true printf("TRUE,");
false printf("FALSE,");
if printf("IF,");
else printf("ELSE,");
then printf("THEN,");
while printf("WHILE,");
do printf("DO,");
for printf("FOR,");
to printf("TO,");
read printf("READ,");
write printf("WRITE,");
function printf("FUNCTION,");
return printf("RETURN,");
null printf("NULL_VALUE,");
"=" printf("EQ,");
"<" printf("INF,");
"<=" printf("INFEQ,");
">" printf("SUP,");
">=" printf("SUPEQ,");
";" printf("END_STATEMENT,");
^[^a - z A - Z _] printf("IDENTIFIER");

.;

%%
int yywrap() 
{ 
    return 1; 
} 
int main()
{
  yylex();
  return 0;
}