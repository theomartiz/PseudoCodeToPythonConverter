%{
#include <stdio.h>
#include <stdbool.h>
#include <stdarg.h>
#include "node.type.h"

nodeType *opr(int oper, int nops, ...);
nodeType *id(int i);
nodeType *constant(int value);
int yylex(void);

int yyerror(char *s);
int sym[26]; /* symbol table */
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
%token <sIndex> VAR
%nonassoc IFX
%nonassoc ELSE

%token IDENTIFIER DIV MOD AND OR NOT ABS LOG EXP BEG END TRUE FALSE IF THEN WHILE DO FOR TO READ WRITE FUNCTION RETURN NULL_VALUE EQ INF INFEQ SUP SUPEQ NOTEQ COMMA TAB COM_BEG COM_END NEWLINE DECLARATOR ASSIGNATOR

/* The last definition listed has the highest precedence. Consequently multiplication and division have higher
precedence than addition and subtraction. All four operators are left-associative. */
%right ASSIGNATOR DECLARATOR
%left AND OR NOT NOTEQ SUP SUPEQ INF INFEQ EQ
%left '+' '-'
%left '*' '/' DIV MOD 
%nonassoc UMINUS  /*supplies precedence for unary minus */

/// TODO: stmt avec begin/end , for, read/write | definition de fonction et son appel | assignement de variable 
%type <nPtr> declaration expr stmt stmt_list basic_data_type function

/* beginning of rules section */
%%  
/* declaration:
  VAR NEWLINE IDENTIFIER DECLARATOR STRING { $$ = id($3); }
  | VAR NEWLINE IDENTIFIER DECLARATOR STRING { $$ = id($3); } */


declaration:
  VAR NEWLINE IDENTIFIER DECLARATOR STRING { }

basic_data_type:
  INT {$$ = opr(INT, 1, id($1)); }
  | CHAR {$$ = opr(CHAR, 1, id($1)); }
  | STRING {$$ = opr(STRING, 1, id($1)); }
  | BOOLEAN {$$ = opr(BOOLEAN, 1, id($1)); }
  | REAL {$$ = opr(REAL, 1, id($1)); }
  | INT {$$ = opr(INT, 1, id($1)); }
  ;
  
expr: 
  INT { $$ = constant($1); }
  | REAL { $$ = constant($1); }
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

stmt:
  ';' { $$ = opr(';', 2, NULL, NULL); }
  | expr ';' { $$ = $1; }
  | VAR '=' expr ';' { $$ = opr('=', 2, id($1), $3); }
  | WHILE '(' expr ')' stmt { $$ = opr(WHILE, 2, $3, $5); }
  | IF '(' expr ')' stmt %prec IFX { $$ = opr(IF, 2, $3, $5); }
  | IF '(' expr ')' stmt ELSE stmt { $$ = opr(IF, 3, $3, $5, $7); }
  | BEG NEWLINE stmt ',' NEWLINE END { $$ = opr(BEG, 1, $3); }
  | FOR VAR '=' INT TO INT DO stmt { $$ = opr(FOR, 4, id($2), $4, $6, $8); }
  | WHILE expr DO stmt { $$ = opr(WHILE, 2, $2, $4); }
  | DO stmt WHILE expr { $$ = opr(DO, 2, $2, $4); }
  | READ '(' basic_data_type ',' VAR ')' { $$ = opr(READ, 2, $3, id($5)); }
  | WRITE '(' basic_data_type ',' VAR ')' { $$ = opr(WRITE, 2, $3, id($5)); }
  | '{' stmt_list '}' { $$ = $2; }
  ;


stmt_list:
  stmt { $$ = $1; }
  | stmt_list stmt { $$ = opr(';', 2, $1, $2); }
  ;

function:
  FUNCTION STRING '(' declaration ')' ':' basic_data_type NEWLINE stmt NEWLINE RETURN basic_data_type { $$ = opr(FUNCTION, , $2, id($4), $9, id($12); }
  ;
%%

#define SIZEOF_NODETYPE ((char *)&p->constant - (char *)p)

nodeType *constant(int value) {
  nodeType *node;
  /* allocate node */
  if ((node = malloc(sizeof(nodeType))) == NULL)
  yyerror("out of memory");
  /* copy information */
  node->type = typeConstant;
  node->constant.value = value;
  return node;
}

nodeType *id(int i) {
  nodeType *node;
  /* allocate node */
  if ((node = malloc(sizeof(nodeType))) == NULL)
  yyerror("out of memory");
  /* copy information */
  node->type = typeId;
  node->id.i = i;
  return node;
}

nodeType *opr(int oper, int nops, ...) {
  va_list ap;
  nodeType *node;
  int i;
  /* allocate node, extending op array */
  if ((node = malloc(sizeof(nodeType) + (nops-1) * sizeof(nodeType *))) == NULL)
  yyerror("out of memory");
  /* copy information */
  node->type = typeOpr;
  node->opr.oper = oper;
  node->opr.nops = nops;
  va_start(ap, nops);
  for (i = 0; i < nops; i++)
    node->opr.op[i] = va_arg(ap, nodeType*);
  va_end(ap);
  return node;
}
  
void freeNode(nodeType *node) {
  int i;
  if (!node) return;
  if (node->type == typeOpr) {
    for (i = 0; i < node->opr.nops; i++)
      freeNode(node->opr.op[i]);
  }
  free(node);
}

int yyerror(char *s) {
  fprintf(stderr, "%s\n", s);
  return 0;
}

int main(void)
{
  yyparse();
  return 0;
}