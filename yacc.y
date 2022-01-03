%{
#include <stdio.h>
#include <stdbool.h>
#include "node.type.h"

nodeType *opr(int oper, int nops, ...);
nodeType *id(int i);
nodeType *con(int value);

void yyerror(char *s);
%}

/* Basic data types */
%union {
  int intValue; /* integer value */
  char charValue; /* char value */
  char *strValue; /* string value */
  bool boolValue; /* boolean value */
  long double realValue; /* real value */
  char sIndex; /* symbol table index */
  nodeType *nPtr; /* node pointer */
};

%token <intValue> INT
%token <charValue> CHAR
%token <strValue> STRING
%token <boolValue> BOOLEAN
%token <realValue> REAL

%token IDENTIFIER NUMBER VAR DIV MOD AND OR NOT ABS LOG EXP BEG END TRUE FALSE IF THEN ELSE WHILE DO FOR TO READ WRITE FUNCTION RETURN NULL_VALUE EQ INF INFEQ SUP SUPEQ NOTEQ COMMA TAB COM_BEG COM_END NEWLINE DECLARATOR ASSIGNATOR

/* The last definition listed has the highest precedence. Consequently multiplication and division have higher
precedence than addition and subtraction. All four operators are left-associative. */
%left AND OR NOT NOTEQ SUP SUPEQ INF INFEQ
%left '+' '-'
%left '*' '/' DIV MOD
%nonassoc UMINUS  /*supplies precedence for unary minus */

%type <nPtr> declaration expr 

/* beginning of rules section */
%%  

declaration:
  VAR NEWLINE IDENTIFIER DECLARATOR { ; }

expr: 
  INT { $$ = con($1); }
  | REAL { $$ = con($1); }
  | '-' expr %prec UMINUS { $$ = opr(UMINUS, 1, $2); }
  | expr '+' expr  { $$ = opr('+', 2, $1, $3); }
  | expr '-' expr  { $$ = opr('-', 2, $1, $3); }
  | expr '*' expr  { $$ = opr('*', 2, $1, $3); }
  | expr '/' expr  { $$ = opr('/', 2, $1, $3); }
  | expr INF expr  { $$ = opr(INF, 2, $1, $3); }
  | expr AND expr  { $$ = opr(AND, 2, $1, $3); }
  | expr OR expr  { $$ = opr(OR, 2, $1, $3); }
  | expr NOT expr  { $$ = opr(NOT, 2, $1, $3); }
  | expr SUP expr  { $$ = opr(SUP, 2, $1, $3); }
  | expr SUPEQ expr  { $$ = opr(GE, 2, $1, $3); }
  | expr INFEQ expr  { $$ = opr(LE, 2, $1, $3); }
  | expr NOTEQ expr  { $$ = opr(NE, 2, $1, $3); }
  | expr EQ expr  { $$ = opr(EQ, 2, $1, $3); }
  | expr DIV expr  { $$ = opr(DIV, 2, $1, $3); }
  | expr MOD expr { $$ = opr(MOD, 2, $1, $3); }
  | '(' expr ')'  { $$ = $2; }
  ;
%%
nodeType *id(int i) {
  nodeType *p;
  /* allocate node */
  if ((p = malloc(sizeof(nodeType))) == NULL)
  yyerror("out of memory");
  /* copy information */
  p->type = typeId;
  p->id.i = i;
  return p;
}

main() { 
  yyparse();
  return 0;
}

void yyerror(char *s){
  fprintf(stderr, "%s\n",s);
}

yywrap(){
  return(1);
}