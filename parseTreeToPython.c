#include <stdlib.h>
#include <stdio.h>
#include <string.h>

void writeStringInPythonFile(char *s);
void findBasicDataType(B_TREE t);
void appendTab(int nb);
void writeRealInPythonFile(long double realValue);
void writeIntInPythonFile(int intValue);


void parseTreeToPython(B_TREE t, int stmt_block_counter)
{
    // TODO(): check stmt, stmtblock etc, check begin/end, check func call
    // Actuellement le If fonctionne avec un seul statement. Voir comment faire marcher les block, idem pour le for
    // Les fonctions ont forcément un statement block, donc on a pas réussi à finir cet aspect.
    
    if (t == NULL)
      return;

    if (strcmp(labels[(t->nodeIdentifier)], "COMMENT_BLOCK") == 0)
    {
        printf("written for nodeIdentifier: %s\n", labels[(t->nodeIdentifier)]);
        writeStringInPythonFile("#");
        writeStringInPythonFile(t->val.v.s);
    }
    else if (strcmp(labels[(t->nodeIdentifier)], "PARENTHESIS") == 0) 
    {
        writeStringInPythonFile("(");
        parseTreeToPython(t->first,stmt_block_counter);
        writeStringInPythonFile(")");
    } 
    else if (strcmp(labels[(t->nodeIdentifier)], "OPPOSITE") == 0) 
    {
        writeStringInPythonFile("-");
        parseTreeToPython(t->first,stmt_block_counter);
    } 
    else if (strcmp(labels[(t->nodeIdentifier)], "ADDITION") == 0)
    {
        printf("written for nodeIdentifier: %s\n", labels[(t->nodeIdentifier)]);
        parseTreeToPython(t->first,stmt_block_counter);
        writeStringInPythonFile(" + ");
        parseTreeToPython(t->second,stmt_block_counter);
    } 
    else if (strcmp(labels[(t->nodeIdentifier)], "SOUSTRACTION") == 0) 
    {
        parseTreeToPython(t->first,stmt_block_counter);
        writeStringInPythonFile(" - ");
        parseTreeToPython(t->second,stmt_block_counter);
    } 
    else if (strcmp(labels[(t->nodeIdentifier)], "MULTIPLICATION") == 0)
    {
        parseTreeToPython(t->first,stmt_block_counter);
        writeStringInPythonFile(" * ");
        parseTreeToPython(t->second,stmt_block_counter);
    }
    else if (strcmp(labels[(t->nodeIdentifier)], "DIVISION") == 0)
    {
        parseTreeToPython(t->first,stmt_block_counter);
        writeStringInPythonFile(" / ");
        parseTreeToPython(t->second,stmt_block_counter);
        
    }
    else if (strcmp(labels[(t->nodeIdentifier)], "INT_DIVISION") == 0)
    {
        parseTreeToPython(t->first,stmt_block_counter);
        writeStringInPythonFile(" // ");
        parseTreeToPython(t->second,stmt_block_counter);
        
    }
    else if (strcmp(labels[(t->nodeIdentifier)], "MODULO") == 0)
    {
        parseTreeToPython(t->first,stmt_block_counter);
        writeStringInPythonFile(" % ");
        parseTreeToPython(t->second,stmt_block_counter);
    }
    else if (strcmp(labels[(t->nodeIdentifier)], "EXP_FUNC") == 0)
    {
        writeStringInPythonFile("math.exp(");
        parseTreeToPython(t->first,stmt_block_counter);
        writeStringInPythonFile(" ) ");
    }
    else if (strcmp(labels[(t->nodeIdentifier)], "LOG_FUNC") == 0)
    {
        writeStringInPythonFile("math.log(");
        parseTreeToPython(t->first,stmt_block_counter);
        writeStringInPythonFile(") ");
    }
    else if (strcmp(labels[(t->nodeIdentifier)], "ABS_FUNC") == 0)
    {
        writeStringInPythonFile("abs(");
        parseTreeToPython(t->first,stmt_block_counter);
        writeStringInPythonFile(") ");
    }
    else if (strcmp(labels[(t->nodeIdentifier)], "SUPERIOR") == 0)
    {
        printf("written for nodeIdentifier: %s\n", labels[(t->nodeIdentifier)]);
        parseTreeToPython(t->first,stmt_block_counter);
        writeStringInPythonFile(" > ");
        parseTreeToPython(t->second,stmt_block_counter);
    }
    else if (strcmp(labels[(t->nodeIdentifier)], "INFERIOR") == 0)
    {
        printf("written for nodeIdentifier: %s\n", labels[(t->nodeIdentifier)]);
        parseTreeToPython(t->first,stmt_block_counter);
        writeStringInPythonFile(" < ");
        parseTreeToPython(t->second,stmt_block_counter);
    }
    else if (strcmp(labels[(t->nodeIdentifier)], "SUPERIOR_EQUAL") == 0)
    {
        printf("written for nodeIdentifier: %s\n", labels[(t->nodeIdentifier)]);
        parseTreeToPython(t->first,stmt_block_counter);
        writeStringInPythonFile(" >= ");
        parseTreeToPython(t->second,stmt_block_counter);
    }
    else if (strcmp(labels[(t->nodeIdentifier)], "INFERIOR_EQUAL") == 0)
    {
        printf("written for nodeIdentifier: %s\n", labels[(t->nodeIdentifier)]);
        parseTreeToPython(t->first,stmt_block_counter);
        writeStringInPythonFile(" <= ");
        parseTreeToPython(t->second,stmt_block_counter);
    }
    else if (strcmp(labels[(t->nodeIdentifier)], "NOT_EQUAL") == 0)
    {
        printf("written for nodeIdentifier: %s\n", labels[(t->nodeIdentifier)]);
        parseTreeToPython(t->first,stmt_block_counter);
        writeStringInPythonFile(" != ");
        parseTreeToPython(t->second,stmt_block_counter);
    }
    else if (strcmp(labels[(t->nodeIdentifier)], "EQUAL") == 0)
    {
        printf("written for nodeIdentifier: %s\n", labels[(t->nodeIdentifier)]);
        parseTreeToPython(t->first,stmt_block_counter);
        writeStringInPythonFile(" == ");
        parseTreeToPython(t->second,stmt_block_counter);
    }
    else if (strcmp(labels[(t->nodeIdentifier)], "AND_OP") == 0)
    {
        printf("written for nodeIdentifier: %s\n", labels[(t->nodeIdentifier)]);
        parseTreeToPython(t->first,stmt_block_counter);
        writeStringInPythonFile("and ");
        parseTreeToPython(t->second,stmt_block_counter);
    }
    else if (strcmp(labels[(t->nodeIdentifier)], "OR_OP") == 0)
    {
        printf("written for nodeIdentifier: %s\n", labels[(t->nodeIdentifier)]);
        parseTreeToPython(t->first,stmt_block_counter);
        writeStringInPythonFile("or ");
        parseTreeToPython(t->second,stmt_block_counter);
    }
    else if (strcmp(labels[(t->nodeIdentifier)], "NOT_OP") == 0)
    {
        printf("written for nodeIdentifier: %s\n", labels[(t->nodeIdentifier)]);
        writeStringInPythonFile("not(");
        parseTreeToPython(t->first,stmt_block_counter);
        parseTreeToPython(t->second,stmt_block_counter);
        writeStringInPythonFile(")");
    }
    else if (strcmp(labels[(t->nodeIdentifier)], "CONSTANT_EXPR") == 0)
    {
        printf("written for nodeIdentifier: %s\n", labels[(t->nodeIdentifier)]);
        parseTreeToPython(t->first,stmt_block_counter);
    }
    else if (strcmp(labels[(t->nodeIdentifier)], "CONSTANT") == 0)
    {
        printf("written for nodeIdentifier: %s\n", labels[(t->nodeIdentifier)]);
        findBasicDataType(t);
    }
    else if (strcmp(labels[(t->nodeIdentifier)], "DECLARATION") == 0)
    {
        printf("written for nodeIdentifier: %s\n", labels[(t->nodeIdentifier)]);
        parseTreeToPython(t->first,stmt_block_counter);
        writeStringInPythonFile(" = ");
        writeStringInPythonFile("None ");
        writeStringInPythonFile("\n");
    }
    else if (strcmp(labels[(t->nodeIdentifier)], "ASSIGNATION") == 0)
    {
        printf("written for nodeIdentifier: %s\n", labels[(t->nodeIdentifier)]);
        parseTreeToPython(t->first,stmt_block_counter);
        writeStringInPythonFile(" = ");
        parseTreeToPython(t->second,stmt_block_counter);
        writeStringInPythonFile("\n");
    }
    else if (strcmp(labels[(t->nodeIdentifier)], "ID") == 0)
    {
        printf("written for nodeIdentifier: %s\n", labels[(t->nodeIdentifier)]);
        writeStringInPythonFile(t->val.v.s);
    }
    else if (strcmp(labels[(t->nodeIdentifier)], "IF_ELSE_STMT") == 0)
    {
        printf("written for nodeIdentifier: %s\n", labels[(t->nodeIdentifier)]);
        appendTab(stmt_block_counter);
        writeStringInPythonFile("if ");       

        parseTreeToPython(t->first,stmt_block_counter);
        writeStringInPythonFile(":\n");
        parseTreeToPython(t->second,stmt_block_counter+1);
        if (t->third != NULL) {
          appendTab(stmt_block_counter);
          writeStringInPythonFile("else");
          writeStringInPythonFile(":\n");
          parseTreeToPython(t->third,stmt_block_counter+1);
        }
    }
    else if (strcmp(labels[(t->nodeIdentifier)], "FOR_LOOP") == 0)
    {
        appendTab(stmt_block_counter);
        writeStringInPythonFile("for ");
        parseTreeToPython(t->first,stmt_block_counter);
        writeStringInPythonFile(" in range(");
        parseTreeToPython(t->second,stmt_block_counter);
        writeStringInPythonFile(")"); 
        writeStringInPythonFile(":\n");;
        parseTreeToPython(t->third,stmt_block_counter+1);
    }

    else if (strcmp(labels[(t->nodeIdentifier)], "WHILE_LOOP") == 0)
    {
        printf("written for nodeIdentifier: %s\n", labels[(t->nodeIdentifier)]);
        // while
        appendTab(stmt_block_counter);
        writeStringInPythonFile("while ");
        parseTreeToPython(t->first,stmt_block_counter);
        writeStringInPythonFile(":\n");
        parseTreeToPython(t->second,stmt_block_counter+1);
    }
    else if (strcmp(labels[(t->nodeIdentifier)], "WRITE_STMT") == 0)
    {
        printf("written for nodeIdentifier: %s\n", labels[(t->nodeIdentifier)]);
        appendTab(stmt_block_counter);
        writeStringInPythonFile("print(");
        parseTreeToPython(t->first,stmt_block_counter);
        writeStringInPythonFile(")\n");
    }
    else if (strcmp(labels[(t->nodeIdentifier)], "READ_STMT") == 0)
    {
        printf("written for nodeIdentifier: %s\n", labels[(t->nodeIdentifier)]);
        appendTab(stmt_block_counter);
        parseTreeToPython(t->first,stmt_block_counter);
        writeStringInPythonFile(" = input(\"Waiting for user input... \" )\n");
    }
    else if (strcmp(labels[(t->nodeIdentifier)], "FUNC_STMT") == 0)
    {
        printf("written for nodeIdentifier: %s\n", labels[(t->nodeIdentifier)]);
        appendTab(stmt_block_counter);
        writeStringInPythonFile("def ");
        parseTreeToPython(t->first,stmt_block_counter);
        writeStringInPythonFile("(");
        parseTreeToPython(t->second,stmt_block_counter);
        writeStringInPythonFile(")");
        writeStringInPythonFile(":\n");
        parseTreeToPython(t->fourth,stmt_block_counter+1);
    }
    else if (strcmp(labels[(t->nodeIdentifier)], "STMT") == 0){
      printf("nothing written for nodeIdentifier: %s\n", labels[(t->nodeIdentifier)]);
      appendTab(stmt_block_counter);
      parseTreeToPython(t->first,stmt_block_counter);
    }
    else if (strcmp(labels[(t->nodeIdentifier)], "STMT_BLOCK_RETURN") == 0){
      parseTreeToPython(t->first,stmt_block_counter);
      appendTab(stmt_block_counter);
      writeStringInPythonFile("return ");
      parseTreeToPython(t->second,stmt_block_counter);
      writeStringInPythonFile("\n");
    }
    else
    {
        printf("nothing written for nodeIdentifier: %s\n", labels[(t->nodeIdentifier)]);
        parseTreeToPython(t->first,stmt_block_counter);
        parseTreeToPython(t->second,stmt_block_counter);
        parseTreeToPython(t->third,stmt_block_counter);
        parseTreeToPython(t->fourth,stmt_block_counter);
    }
}

void appendTab(int nb){
  for (int i = 0; i < nb; i++){
    writeStringInPythonFile("\t");
  }
}

void findBooleanOperator(char *s)
{
    if (strcmp(s, "EQUAL") == 0)
    {
        writeStringInPythonFile("== ");
    }
    else if (strcmp(s, "INFERIOR") == 0)
    {
        writeStringInPythonFile("< ");
    }
    else if (strcmp(s, "SUPERIOR") == 0)
    {
        writeStringInPythonFile("> ");
    }
    else if (strcmp(s, "SUPERIOR_EQUAL") == 0)
    {
        writeStringInPythonFile(">= ");
    }
    else if (strcmp(s, "INFERIOR_EQUAL") == 0)
    {
        writeStringInPythonFile("<= ");
    }
    else if (strcmp(s, "NOT_EQUAL") == 0)
    {
        writeStringInPythonFile("!= ");
    }
}

void findBasicDataType(B_TREE t)
{
    if (strcmp(t->val.use, "real") == 0)
    {
        writeRealInPythonFile(t->val.v.r);
    }
    else if (strcmp(t->val.use, "int") == 0)
    {
        writeIntInPythonFile(t->val.v.i);
    }
    else if (strcmp(t->val.use, "bool") == 0)
    {
        writeStringInPythonFile(t->val.v.b ? "True" : "False");
    }
    else if (strcmp(t->val.use, "string") == 0)
    {
        writeStringInPythonFile(t->val.v.s);
    }
}

void findMathOperator(char *s)
{
    //TODO() : add exponential?
    if (strcmp(s, "ADDITION") == 0)
    {
        writeStringInPythonFile("+ ");
    }
    else if (strcmp(s, "SOUSTRACTION") == 0)
    {
        writeStringInPythonFile("- ");
    }
    else if (strcmp(s, "MULTIPLICATION") == 0)
    {
        writeStringInPythonFile("* ");
    }
    else if (strcmp(s, "DIVISION") == 0)
    {
        writeStringInPythonFile("/ ");
    }
    else if (strcmp(s, "INT_DIVISION") == 0)
    {
        writeStringInPythonFile("// ");
    }
    else if (strcmp(s, "MODULO") == 0)
    {
        writeStringInPythonFile("% ");
    }
}

void writeStringInPythonFile(char *s)
{
    FILE *fptr;
    fptr = fopen("./code.py", "ab");

    if (fptr == NULL)
    {
        printf("Error!");
        exit(1);
    }
    fprintf(fptr, "%s", s);
    fclose(fptr);
}

void writeRealInPythonFile(long double realValue)
{
    FILE *fptr;
    fptr = fopen("./code.py", "ab");

    if (fptr == NULL)
    {
        printf("Error!");
        exit(1);
    }
    fprintf(fptr, "%Lf", realValue);
    fclose(fptr);
}

void writeIntInPythonFile(int intValue)
{
    FILE *fptr;
    fptr = fopen("./code.py", "ab");

    if (fptr == NULL)
    {
        printf("Error!");
        exit(1);
    }
    fprintf(fptr, "%d", intValue);
    fclose(fptr);
}


