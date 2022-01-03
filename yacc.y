%{
#include <stdio.h>
#include <stdbool.h>
#include <stdarg.h> 
#include "hashing.c"

#define SYMTABSIZE	997
#define IDLENGTH	15

enum PARSE_TREE_NODE_TYPE {DECLARATION,TYPE_SPECIFIER, DECLARATION_BLOCK, DECLARATION_LIST, ID, ADDITION};
const char* labels[] = {"DECLARATION","TYPE_SPECIFIER", "DECLARATION_BLOCK", "DECLARATION_LIST", "ID", "ADDITION"};

char *id[100];
char *type[100];

int yylex();
int yyerror(char *s);

/* parse tree */
struct TreeNode {
	struct TreeValue{
		union {
			int i;
			long double f;
			char *s;
		} v;
		char *use;
	} val;
	int nodeIdentifier;
	struct TreeNode *first;
	struct TreeNode *second;
	struct TreeNode *third;
	struct TreeNode *fourth;
};
typedef struct TreeNode TREE_NODE;
typedef TREE_NODE *B_TREE;
B_TREE create_node(struct TreeValue, int, B_TREE, B_TREE, B_TREE, B_TREE);
int find_usage(B_TREE, char *type[100], int, char *u);
B_TREE tree_to_print;

/* symbol table */
struct symTabNode {
	char identifier[IDLENGTH];
	char type[100];
};
typedef struct symTabNode SYMTABNODE;
typedef SYMTABNODE *SYMTABNODEPTR;
SYMTABNODEPTR symTab[SYMTABSIZE];
int currentSymTabSize=0;

void PrintTree(B_TREE);
%}

/* Basic data types */
%union {
  int intValue; /* integer value */
  char charValue; /* char value */
  char *strValue; /* string value */
  bool boolValue; /* boolean value */
  long double realValue; /* real value */
  B_TREE treeVal; /* node pointer */
};

%token <intValue> INT_VALUE
%token <charValue> CHAR
%token <strValue> IDENTIFIER STRING
%token <boolValue> BOOLEAN
%token <realValue> REAL_VALUE

%token VAR DIV MOD AND OR NOT ABS LOG EXP BEG END TRUE FALSE IF THEN ELSE WHILE DO FOR TO READ WRITE FUNCTION RETURN NULL_VALUE EQ INF INFEQ SUP SUPEQ NOTEQ COMMA TAB COM_BEG COM_END NEWLINE DECLARATOR ASSIGNATOR INT REAL

/* The last definition listed has the highest precedence. Consequently multiplication and division have higher
precedence than addition and subtraction. All four operators are left-associative. */
%right ASSIGNATOR DECLARATOR
%left AND OR NOT NOTEQ SUP SUPEQ INF INFEQ EQ
%left '+' '-'
%left '*' '/' DIV MOD 
%nonassoc UMINUS  /*supplies precedence for unary minus */
%nonassoc IFX
%nonassoc ELSE

%type <treeVal> declaration_block declaration expr type_specifier declaration_list id_declaration stmt_list stmt function

/* beginning of rules section */
%%  
declaration_block:
  VAR NEWLINE declaration { 
      struct TreeValue empty_node; empty_node.use="none";
      $$ = create_node(empty_node,DECLARATION_BLOCK,$3,NULL,NULL,NULL); 
  }
  |
  declaration_block declaration { 
      struct TreeValue empty_node; empty_node.use="none";
      $$ = create_node(empty_node,DECLARATION_BLOCK,$1,$2,NULL,NULL); 
  }
  ;

declaration:
  declaration_list DECLARATOR type_specifier NEWLINE {
      struct TreeValue empty_node; empty_node.use="none";
      $$ = create_node(empty_node,DECLARATION,$1,$3,NULL,NULL);
      int i, j, type_index = 0, id_index = 0;
      for(i = 0; i < 100; i++) {
        id[i] = (char *)malloc(IDLENGTH*sizeof(char));
        strcpy(id[i],"NULL");
        type[i] = (char *)malloc(10*sizeof(char));
        strcpy(type[i],"NULL");
      }
      
      id_index = find_usage($1,id,id_index,"identifier");
      type_index = find_usage($3,type,type_index,"string");
      for(i=0;i<id_index;i++) {
        for(j=1;j<type_index;j++) {
          if(strcmp(type[j],"NULL")!=0) {
            strcat(type[0]," ");
            strcat(type[0],type[j]);
          }
        }
        hash_insert(id[i],type[0]);
      }
	  }
  ;

declaration_list: 
  id_declaration { 
    struct TreeValue empty_node; empty_node.use="none";
		$$ = create_node(empty_node,DECLARATION_LIST,$1,NULL,NULL,NULL);
  }
  | declaration_list COMMA id_declaration { 
      struct TreeValue empty_node; empty_node.use="none";
      $$ = create_node(empty_node,DECLARATION_LIST,$1,$3,NULL,NULL); 
    }
  ;

id_declaration:
  IDENTIFIER { 
    struct TreeValue new_node;
		new_node.v.s = yylval.strValue;
		new_node.use = "identifier";
		$$ = create_node(new_node,ID,NULL,NULL,NULL,NULL);
    PrintTree($$);
  }
  ;

type_specifier:
  INT { 
    struct TreeValue new_node;
		new_node.v.s = "int";
		new_node.use = "string";
    $$ = create_node(new_node,TYPE_SPECIFIER,NULL,NULL,NULL,NULL); 
  }
  | CHAR {
    struct TreeValue new_node;
		new_node.v.s = "char";
		new_node.use = "string";
    $$ = create_node(new_node,TYPE_SPECIFIER,NULL,NULL,NULL,NULL); 
  }
  | STRING {
    struct TreeValue new_node;
		new_node.v.s = "string";
		new_node.use = "string";
    $$ = create_node(new_node,TYPE_SPECIFIER,NULL,NULL,NULL,NULL); 
  }
  | BOOLEAN {
    struct TreeValue new_node;
		new_node.v.s = "bool";
		new_node.use = "string";
    $$ = create_node(new_node,TYPE_SPECIFIER,NULL,NULL,NULL,NULL); 
  }
  | REAL {
    struct TreeValue new_node;
		new_node.v.s = "real";
		new_node.use = "string";
    $$ = create_node(new_node,TYPE_SPECIFIER,NULL,NULL,NULL,NULL); 
  }
  ;

  
expr: 
  INT_VALUE { 
    struct TreeValue new_node;
    new_node.v.i = yyval.intValue;
    $$ = createNode(new_node, CONSTANT, $1, NULL, NULL, NULL);  
  }
  | REAL_VALUE { 
    struct TreeValue new_node;
    new_node.v.f = yyval.realValue;
    $$ = createNode(new_node, CONSTANT, $1, NULL, NULL, NULL); 
   }
  | '-' expr %prec UMINUS { 
    struct TreeValue new_node;
    new_node.v.f = yyval.intValue;
    $$ = createNode(new_node, CONSTANT, $1, NULL, NULL, NULL);  
  }
  | expr '+' expr  { struct TreeValue empty_node; empty_node.use="none"; $$ = createNode(empty_node, ADDITION, $1, $3, NULL, NULL); }
  | expr '-' expr  { struct TreeValue empty_node; empty_node.use="none"; $$ = createNode(empty_node, SOUSTRACTION, $1, $3, NULL, NULL); }
  | expr '*' expr  { struct TreeValue empty_node; empty_node.use="none"; $$ = createNode(empty_node, MULTIPLICATION, $1, $3, NULL, NULL); }
  | expr '/' expr  { struct TreeValue empty_node; empty_node.use="none"; $$ = createNode(empty_node, DIVISION, $1, $3, NULL, NULL); }
  | expr INF expr  { struct TreeValue empty_node; empty_node.use="none"; $$ = createNode(empty_node, INF, $1, $3, NULL, NULL); }
  | expr AND expr  { struct TreeValue empty_node; empty_node.use="none"; $$ = createNode(empty_node, AND, $1, $3, NULL, NULL); }
  | expr OR expr  { struct TreeValue empty_node; empty_node.use="none"; $$ = createNode(empty_node, OR, $1, $3, NULL, NULL); }
  | expr NOT expr  { struct TreeValue empty_node; empty_node.use="none"; $$ = createNode(empty_node, NOT, $1, $3, NULL, NULL); }
  | expr SUP expr  { struct TreeValue empty_node; empty_node.use="none"; $$ = createNode(empty_node, SUP, $1, $3, NULL, NULL); }
  | expr SUPEQ expr  { struct TreeValue empty_node; empty_node.use="none"; $$ = createNode(empty_node, SUPEQ, $1, $3, NULL, NULL); }
  | expr INFEQ expr  { struct TreeValue empty_node; empty_node.use="none"; $$ = createNode(empty_node, INFEQ, $1, $3, NULL, NULL); }
  | expr NOTEQ expr  { struct TreeValue empty_node; empty_node.use="none"; $$ = createNode(empty_node, NOTEQ, $1, $3, NULL, NULL); }
  | expr EQ expr  { struct TreeValue empty_node; empty_node.use="none"; $$ = createNode(empty_node, EQ, $1, $3, NULL, NULL); }
  | expr DIV expr  { struct TreeValue empty_node; empty_node.use="none"; $$ = createNode(empty_node, DIV, $1, $3, NULL, NULL); }
  | expr MOD expr { struct TreeValue empty_node; empty_node.use="none"; $$ = createNode(empty_node, MOD, $1, $3, NULL, NULL); }
  | '(' expr ')'  { $$ = $2; }
  ;
%%

B_TREE create_node(struct TreeValue val, int case_identifier, B_TREE p1, B_TREE p2, B_TREE p3, B_TREE p4) {
	B_TREE t;
	t = (B_TREE)malloc(sizeof(TREE_NODE));
	t->val = val;
	t->nodeIdentifier = case_identifier;
	t->first = p1;
	t->second = p2;
	t->third = p3;
	t->fourth = p4;
	return (t);
}

int find_usage(B_TREE p,char *type[100],int i,char *u) {
  if(p == NULL)
    return i;
  if(strcmp(p->val.use,u) == 0) {
    strcpy(type[i],p->val.v.s);
    i++;
  }
  i=find_usage(p->first,type,i,u);
  i=find_usage(p->second,type,i,u);
  i=find_usage(p->third,type,i,u);
  i=find_usage(p->fourth,type,i,u);
  return i;
}

void PrintTree(B_TREE t) {
	if(t==NULL)
		return; 
	if(strcmp(t->val.use,"string")==0)
		printf("Value: %s ",t->val.v.s);
	if(strcmp(t->val.use,"identifier")==0)
		printf("Value: %s ",t->val.v.s);
	else if(strcmp(t->val.use,"float")==0)
		printf("Value: %Lf ",t->val.v.f);
	else if(strcmp(t->val.use,"integer")==0)
		printf("Value: %d ",t->val.v.i);
	else 
		printf("Value: ");

	printf("Label: %s\n",labels[(t->nodeIdentifier)]);
	//if(t->first!=NULL) printf("Going from %s to %s\n",labels[t->nodeIdentifier],labels[t->first->nodeIdentifier]);
	PrintTree(t->first);
	//if(t->second!=NULL) printf("Going from %s to %s\n",labels[t->nodeIdentifier],labels[t->second->nodeIdentifier]);
	PrintTree(t->second);
	//if(t->third!=NULL) printf("Going from %s to %s\n",labels[t->nodeIdentifier],labels[t->third->nodeIdentifier]);
	PrintTree(t->third);
	//if(t->fourth!=NULL) printf("Going from %s to %s\n",labels[t->nodeIdentifier],labels[t->fourth->nodeIdentifier]);
	PrintTree(t->fourth);
}

int yyerror(char *s) {
  fprintf(stderr, "%s\n", s);
  return 0;
}