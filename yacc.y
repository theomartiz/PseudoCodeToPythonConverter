%{
#include <stdio.h>
%}

%token IDENTIFIER VAR STRING CHAR INT REAL BOOLEAN DIV MOD AND OR NOT ABS LOG EXP BEG END TRUE FALSE IF THEN ELSE WHILE DO FOR TO READ WRITE FUNCTION RETURN NULL_VALUE EQ INF INFEQ SUP SUPEQ NOTEQ
%left '+' '-'
%left '*' '/' '%'

/* beginning of rules section */
%%  
ArithmeticExpression: E{
         printf("\nResult=%d\n", $$);
         return 0;
        };
 E:E'+'E {$$=$1+$3;}
  
 |E'-'E {$$=$1-$3;}
  
 |E'*'E {$$=$1*$3;}
  
 |E'/'E {$$=$1/$3;}
  
 |E'%'E {$$=$1%$3;}
  
 |'('E')' {$$=$2;}
  
 | INT {$$=$1;}
  
 ;                 

%%
main()
{
 return(yyparse());
}
yyerror(s)
char *s;
{
  fprintf(stderr, "%s\n",s);
}
yywrap()
{
  return(1);
}