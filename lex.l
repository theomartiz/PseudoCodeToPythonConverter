digit [0-9]
letter [A-Za-z]
%{
#include <stdlib.h>
#include "yacc.tab.h"
%}

%%
 
 /* Boolean operators */
"=" printf("EQ,");
"<" printf("INF,");
"<=" printf("INFEQ,");
">" printf("SUP,");
">=" printf("SUPEQ,");
"<>" printf("NOTEQ,");
and printf("AND,");
or printf("OR,");
not printf("NOT,");
 
 /* Declaration & assignation of variables */
: printf("DECLARATOR,");
:=  printf("ASSIGNATOR,");
var printf("VAR,");

 /* Mathematical functions */
abs printf("ABS,");
log printf("LOG,");
exp printf("EXP,");

  /* Data types */
string printf("STRING,");
char printf("CHAR,");
int printf("INT,");
real printf("REAL,");
boolean printf("BOOLEAN,");

  /* Conditional statements */
if printf("IF,");
else printf("ELSE,");
then printf("THEN,");

  /* Loop Statement */
do printf("DO,");
while printf("WHILE,");
for printf("FOR,");
to printf("TO,");

  /* Group Statement */
begin printf("BEG,");
end printf("END,");

  /* Read and write statements */
read printf("READ,");
write printf("WRITE,");

  /* Functions */
function printf("FUNCTION,");

  /* Values */
true printf("TRUE,");
false printf("FALSE,");
null printf("NULL_VALUE,");

  /* Return */
return printf("RETURN,");

  /* Comments */
"{" printf("COM_BEG,");
"}" printf("COM_END,");

  /* Others */
\t printf("TAB,");
";" printf("END_STATEMENT,");
"," printf("COMMA,");

[+-]?{digit}+([.]{digit}+)? {
  printf("NUMBER,");
} 

  /* Arithmetic operators */
"+" printf("+,");
"-" printf("-,");
"/" printf("/,");
"*" printf("*,");
div printf("DIV,");
mod printf("MOD,");

  /* Strings */
\"(\\.|[^\\"])*\" {
  printf("STRING,"); 
}

 /* Identifiers */
{letter}({letter}|{digit}|"_")* {
  printf("IDENTIFIER,"); 
}
 
  /* New line */
[\n] printf("NEWLINE,");

 /* skip whitespace */
[ \t] ;

 
  /* anything else is an error */
. ;

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