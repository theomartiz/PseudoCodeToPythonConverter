%{
#include <stdlib.h>
#include "y.tab.h"
%}

%%
  
: printf("DECLARATOR,");
:=  printf("ASSIGNATOR,");
" " printf("SEPARATOR,");
^[^a - z A - Z _] printf("IDENTIFIER");
var printf("VAR,");
string printf("STRING,");
char printf("CHAR,");
int printf("INT,");
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