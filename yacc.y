%{
#include <stdio.h>
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


%token IDENTIFIER NUMBER VAR DIV MOD AND OR NOT ABS LOG EXP BEG END TRUE FALSE IF THEN ELSE WHILE DO FOR TO READ WRITE FUNCTION RETURN NULL_VALUE EQ INF INFEQ SUP SUPEQ NOTEQ COMMA TAB COM_BEG COM_END NEWLINE DECLARATOR

/* The last definition listed has the highest precedence. Consequently multiplication and division have higher
precedence than addition and subtraction. All four operators are left-associative. */
%left AND OR NOT NOTEQ SUP SUPEQ INF INFEQ
%left '+' '-'
%left '*' '/' DIV MOD
%left UMINUS  /*supplies precedence for unary minus */

/* beginning of rules section */
%%  

declaration:
  VAR NEWLINE IDENTIFIER DECLARATOR 

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