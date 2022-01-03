digit [0-9]
letter [A-Za-z]
%{
#include <stdlib.h>
#include <stdbool.h>
#include "y.tab.h"
%}

%%
 
 /* Boolean operators */
"=" return EQ;
"<" return INF;
"<=" return INFEQ;
">" return SUP;
">=" return SUPEQ;
"<>" return NOTEQ;
and return AND;
or return OR;
not return NOT;
 
 /* Declaration & assignation of variables */
: {
   
  return DECLARATOR;
}
:=  return ASSIGNATOR;
var {
   
  return VAR;
}

 /* Mathematical functions */
abs({letter}({letter}|{digit}|"_")*|{digit}+([.]{digit}+)?) return ABS;
log return LOG;
exp return EXP;

  /* Data types */
string {
   
  return STRING;
}
char return CHAR;
int {
   
  return INT;
}
real return REAL;
boolean return BOOLEAN;

  /* Conditional statements */
if return IF;
else return ELSE;
then return THEN;

  /* Loop Statement */
do return DO;
while return WHILE;
for return FOR;
to return TO;

  /* Group Statement */
begin return BEG;
end return END;

  /* Read and write statements */
read return READ;
write return WRITE;

  /* Functions */
function return FUNCTION;

  /* Values */
true return TRUE;
false return FALSE;
null return NULL_VALUE;

  /* Return */
return return RETURN;

  /* Comments */
"{" return COM_BEG;
"}" return COM_END;

  /* Others */
\t return TAB;
"," return COMMA;

  /* Real */
{digit}+([.]{digit}+) {
  yylval.realValue = atof(yytext);
  return REAL;
}

  /* Integers */
{digit}+ {
  yylval.intValue = atoi(yytext);
  return INT;
}

  /* Arithmetic operators */
[-+/$] return *yytext;
div return DIV;
mod return MOD;

  /* Strings */
\"(\\.|[^\\"])*\" {
  return STRING; 
}

 /* Identifiers */
{letter}({letter}|{digit}|"_")* {
  yylval.strValue = yytext;
  return IDENTIFIER;
}
 
  /* New line */
[\n] return NEWLINE;

 /* skip whitespace */
[ \t] ;

 
  /* anything else is an error */
. yyerror("invalid character");

%%
int yywrap(void){
  return 1;
}