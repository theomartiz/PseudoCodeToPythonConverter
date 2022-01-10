digit [0-9]
letter [A-Za-z]
%{
#include <stdlib.h>
#include <stdbool.h>
#include "y.tab.h"

extern int sym_type(const char *);

#include<strings.h>
extern SYMTABNODEPTR symTab[SYMTABSIZE];
extern int currentSymTabSize;
%}

%%
 
 /* Boolean operators */
"=" return EQ;
"<" return INF;
"<=" return INFEQ;
">" return SUP;
">=" return SUPEQ;
"<>" return NOTEQ;
";" return TERMINATOR;
and return AND;
or return OR;
not return NOT;

<<EOF>> return END_INPUT;
 
 /* Declaration & assignation of variables */

:=  return ASSIGNATOR;
var return VAR;

 /* Mathematical functions */
abs return ABS;
log return LOG;
exp return EXP;

  /* Data types */
string return STRING;
char return CHAR;
int return INT;
real return REAL;
boolean return BOOLEAN;
void return VOID;

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

  /* Return */
return return RETURN;

  /* Special characters */
[-/+*()$] {
  return *yytext;
}
div return DIV;
mod return MOD;


  /* VALUES */
  /* Real */
{digit}+([.]{digit}+) {
  yylval.realValue = atof(yytext);
  return REAL_VALUE;
}

  /* Integers */
{digit}+ {
  yylval.intValue = atoi(yytext);
  return INT_VALUE;
}

  /* Character */
\'(\\.|[^\\"])\' {
  yylval.charValue = yytext[1];
  return CHAR_VALUE; 
}

  /* Strings */
\"(\\.|[^\\"])*\" {
  yylval.strValue = strdup(yytext);
  return STRING_VALUE; 
}

"{"(\\.|[^}])*"}" {
  yylval.strValue = strdup(yytext);
  return COMMENT;
}

true {
  yylval.boolValue = 1;
  return BOOLEAN_VALUE;
} 

false {
  yylval.boolValue = 0;
  return BOOLEAN_VALUE;
}

null return NULL_VALUE;

 /* Identifiers */
{letter}({letter}|{digit}|"_")* {
  yylval.strValue = strdup(yytext);
  return IDENTIFIER;
}

: {
  return DECLARATOR;
}
"," return COMMA;

 
  /* New line (several newlines are resolved to one token) */
[\n]* return NEWLINE;

\t return TAB;
"    " return TAB; /* some IDE replace \t by 4 space characters */
 /* skip whitespace */
[ ] {}

 
 /* anything else is ignore */
. {}

%%

int yywrap(void){
  return 1;
}