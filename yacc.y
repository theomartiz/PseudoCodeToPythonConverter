%{
#include <stdio.h>
#include <stdbool.h>
#include <stdarg.h> 
#include "hashing.c"

#define SYMTABSIZE	997
#define IDLENGTH	15

enum PARSE_TREE_NODE_TYPE {PROGRAM, DECLARATION, DECLARATOR_LIST, TYPE_SPECIFIER, DECLARATION_BLOCK, ID, ADDITION, CONSTANT, CONSTANT_EXPR, ASSIGNATION, SOUSTRACTION, MULTIPLICATION, DIVISION, ASSIGNATIONS};
const char* labels[] = {"PROGRAM", "DECLARATION", "DECLARATOR_LIST", "TYPE_SPECIFIER", "DECLARATION_BLOCK", "ID", "ADDITION","CONSTANT", "CONSTANT_EXPR", "ASSIGNATION","SOUSTRACTION", "MULTIPLICATION", "DIVISION", "ASSIGNATIONS"};

char *id[100];
char *type[100];

int yylex();
int yyerror(char *s);

/* parse tree */
struct TreeNode {
	struct TreeValue{
		union {
			int i;
			long double r;
			char *s;
      char c;
      bool b;
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
int find_usage(B_TREE, char *type[100], int, char *use);

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
%token <realValue> REAL_VALUE
%token <charValue> CHAR_VALUE
%token <boolValue> BOOLEAN_VALUE
%token <strValue> IDENTIFIER STRING_VALUE STRING CHAR BOOLEAN


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

%type <treeVal> program declaration_block declaration  declarator_list id_declarator expr type_specifier constant assignation assignations

/* beginning of rules section */
%% 

program:
  declaration_block assignations {
    struct TreeValue empty_node; empty_node.use="none";
    $$ = create_node(empty_node,PROGRAM,$1,$2,NULL,NULL); 
    PrintTree($$);
    exit(0);
  }
  ;

declaration_block:
  VAR NEWLINE TAB declaration {
    struct TreeValue empty_node; empty_node.use="none";
    $$ = create_node(empty_node,DECLARATION_BLOCK,$4,NULL,NULL,NULL); 
  } 
  | declaration_block TAB declaration { 
      struct TreeValue empty_node; empty_node.use="none";
      $$ = create_node(empty_node,DECLARATION_BLOCK,$1,$3,NULL,NULL); 
  }
  ;

declaration:
  declarator_list DECLARATOR type_specifier NEWLINE {
      struct TreeValue empty_node; empty_node.use="none";
      $$ = create_node(empty_node,DECLARATION,$1,$3,NULL,NULL);
      int i, j, type_index = 0, id_index = 0, insert_result;

      for(i = 0; i < 100; i++) {
        id[i] = (char *)malloc(IDLENGTH*sizeof(char));
        strcpy(id[i],"NULL");
        type[i] = (char *)malloc(10*sizeof(char));
        strcpy(type[i],"NULL");
      }
      
      //find the number of ids in the current tree
      id_index = find_usage($1,id,id_index,"identifier");
      //find the number of types declaration in the current tree
      type_index = find_usage($3,type,type_index,"string");

      for(i=0;i<id_index;i++) {
        for(j=1;j<type_index;j++) {
          if(strcmp(type[j],"NULL")!=0) {
            strcat(type[0]," ");
            strcat(type[0],type[j]);
          }
        }
        insert_result = hash_insert(id[i],type[0]);
        if (insert_result == -1){
          char message[35+IDLENGTH] = "Variable ";
          strcat(message,id[i]);
          strcat(message," has already been declared.");
          yyerror(message);
          exit(1);
        }
      }
  }
  ;

declarator_list: 
  id_declarator { 
    struct TreeValue empty_node; empty_node.use="none";
		$$ = create_node(empty_node,DECLARATOR_LIST,$1,NULL,NULL,NULL);
  }
  | declarator_list COMMA id_declarator { 
      struct TreeValue empty_node; empty_node.use="none";
      $$ = create_node(empty_node,DECLARATOR_LIST,$1,$3,NULL,NULL); 
  }
  ;

id_declarator:
  IDENTIFIER { 
    struct TreeValue new_node;
		new_node.v.s = yylval.strValue;
		new_node.use = "identifier";
		$$ = create_node(new_node,ID,NULL,NULL,NULL,NULL);
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

assignations:
  assignation { struct TreeValue empty_node; empty_node.use="none"; $$ = create_node(empty_node, ASSIGNATIONS, $1, NULL, NULL, NULL); }
  | assignations assignation { struct TreeValue empty_node; empty_node.use="none"; $$ = create_node(empty_node, ASSIGNATIONS, $1, $2, NULL, NULL); }

assignation:
  id_declarator ASSIGNATOR expr NEWLINE {
    int id_index;
    id_index = hash_search($1->val.v.s);
    if (id_index == -1){
      char message[32+IDLENGTH] = "Variable ";
      strcat(message,$1->val.v.s);
      strcat(message," has not been declared.");
      yyerror(message);
      exit(1);
    } else if (strcmp(symtab[id_index].type,$3->val.use) != 0){
      char message[70+IDLENGTH] = "Variable ";
      strcat(message,$1->val.v.s);
      strcat(message," type is ");
      strcat(message,symtab[id_index].type);
      strcat(message," but trying to assign a value of type ");
      strcat(message,$3->val.use);
      yyerror(message);
      exit(1);
    } else {
      struct TreeValue empty_node; empty_node.use="none";
      $$ = create_node(empty_node,ASSIGNATION,$1,$3,NULL,NULL);
    }
  }
  | id_declarator ASSIGNATOR id_declarator {}
  ;

constant:
  INT_VALUE { 
    struct TreeValue new_node;
    new_node.use = "int";
    new_node.v.i = yyval.intValue;
    $$ = create_node(new_node, CONSTANT, NULL, NULL, NULL, NULL);  
  }
  | REAL_VALUE { 
    struct TreeValue new_node;
    new_node.use = "real";
    new_node.v.r = yyval.realValue;
    $$ = create_node(new_node, CONSTANT, NULL, NULL, NULL, NULL); 
  } 
  | STRING_VALUE { 
    struct TreeValue new_node;
    new_node.use = "string";
    new_node.v.s = yyval.strValue;
    $$ = create_node(new_node, CONSTANT, NULL, NULL, NULL, NULL); 
  }
  | CHAR_VALUE { 
    struct TreeValue new_node;
    new_node.use = "char";
    new_node.v.c = yyval.charValue;
    $$ = create_node(new_node, CONSTANT, NULL, NULL, NULL, NULL); 
  }
  | BOOLEAN_VALUE { 
    struct TreeValue new_node;
    new_node.use = "bool";
    new_node.v.b = yyval.boolValue;
    $$ = create_node(new_node, CONSTANT, NULL, NULL, NULL, NULL); 
  }
  | NULL_VALUE { 
    struct TreeValue new_node;
    new_node.use = "null";
    $$ = create_node(new_node, CONSTANT, NULL, NULL, NULL, NULL); 
  }
  
expr: 
  constant { 
    struct TreeValue empty_node; 
    empty_node.use=$1->val.use; 
    empty_node.v.s = NULL;
    $$ = create_node(empty_node, CONSTANT_EXPR, $1, NULL, NULL, NULL); 
  }
  | expr '+' expr  { 
    if ($1->val.use == $3->val.use){
      struct TreeValue empty_node; 
      empty_node.use=$1->val.use; 
      empty_node.v.s = NULL;
      $$ = create_node(empty_node, ADDITION, $1, $3, NULL, NULL); 
    } else {
      yyerror("Trying to compute expression of two different types.");
      exit(1);
    }
  }
  | expr '-' expr  { 
    if ($1->val.use == $3->val.use){
      struct TreeValue empty_node; 
      empty_node.use=$1->val.use; 
      empty_node.v.s = NULL;
      $$ = create_node(empty_node, SOUSTRACTION, $1, $3, NULL, NULL); 
    } else {
      yyerror("Trying to compute expression of two different types.");
      exit(1);
    }
  }
  | expr '*' expr  { 
    if ($1->val.use == $3->val.use){
      struct TreeValue empty_node; 
      empty_node.use=$1->val.use; 
      empty_node.v.s = NULL;
      $$ = create_node(empty_node, MULTIPLICATION, $1, $3, NULL, NULL); 
    } else {
      yyerror("Trying to compute expression of two different types.");
      exit(1);
    }
  }
  | expr '/' expr  { struct TreeValue empty_node; empty_node.use="none"; $$ = create_node(empty_node, DIVISION, $1, $3, NULL, NULL); }
  | expr INF expr  { struct TreeValue empty_node; empty_node.use="none"; $$ = create_node(empty_node, INF, $1, $3, NULL, NULL); }
  | expr AND expr  { struct TreeValue empty_node; empty_node.use="none"; $$ = create_node(empty_node, AND, $1, $3, NULL, NULL); }
  | expr OR expr  { struct TreeValue empty_node; empty_node.use="none"; $$ = create_node(empty_node, OR, $1, $3, NULL, NULL); }
  | expr NOT expr  { struct TreeValue empty_node; empty_node.use="none"; $$ = create_node(empty_node, NOT, $1, $3, NULL, NULL); }
  | expr SUP expr  { struct TreeValue empty_node; empty_node.use="none"; $$ = create_node(empty_node, SUP, $1, $3, NULL, NULL); }
  | expr SUPEQ expr  { struct TreeValue empty_node; empty_node.use="none"; $$ = create_node(empty_node, SUPEQ, $1, $3, NULL, NULL); }
  | expr INFEQ expr  { struct TreeValue empty_node; empty_node.use="none"; $$ = create_node(empty_node, INFEQ, $1, $3, NULL, NULL); }
  | expr NOTEQ expr  { struct TreeValue empty_node; empty_node.use="none"; $$ = create_node(empty_node, NOTEQ, $1, $3, NULL, NULL); }
  | expr EQ expr  { struct TreeValue empty_node; empty_node.use="none"; $$ = create_node(empty_node, EQ, $1, $3, NULL, NULL); }
  | expr DIV expr  { struct TreeValue empty_node; empty_node.use="none"; $$ = create_node(empty_node, DIV, $1, $3, NULL, NULL); }
  | expr MOD expr { struct TreeValue empty_node; empty_node.use="none"; $$ = create_node(empty_node, MOD, $1, $3, NULL, NULL); }
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

int find_usage(B_TREE p,char *value[100], int i, char *use) {
  if(p == NULL)
    return i;
  
  //if the given node use is equivalent to the target one ("use"), we get the value of the node into the "value" variable
  //we then add 1 to the given index
  if(strcmp(p->val.use,use) == 0) {
    strcpy(value[i],p->val.v.s);
    i++;
  }

  i=find_usage(p->first,value,i,use);
  i=find_usage(p->second,value,i,use);
  i=find_usage(p->third,value,i,use);
  i=find_usage(p->fourth,value,i,use);
  return i;
}

void PrintTree(B_TREE t) {
	if(t==NULL)
		return; 
  if (t->val.v.s == NULL)
    printf("Value: ");
  else {
    if(strcmp(t->val.use,"string")==0)
      printf("Value: %s ",t->val.v.s);
    if(strcmp(t->val.use,"identifier")==0)
      printf("Value: %s.",t->val.v.s);
    else if(strcmp(t->val.use,"real")==0)
      printf("Value: %Lf ",t->val.v.r);
    else if(strcmp(t->val.use,"int")==0)
      printf("Value: %d ",t->val.v.i);
    else if(strcmp(t->val.use,"char")==0)
      printf("Value: %c ",t->val.v.c);
    else if(strcmp(t->val.use,"bool")==0) {
      if (t->val.v.i == 0)
        printf("Value: False");
      else
        printf("Value: True");
    }
    else if(strcmp(t->val.use,"null")==0)
      printf("Value: NULL");
	else 
		printf("Value: ");
  }

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
  fprintf(stderr, "[ERROR]: %s\n", s);
  return 0;
}