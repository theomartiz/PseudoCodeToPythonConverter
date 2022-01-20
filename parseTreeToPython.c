#include "parse_tree_to_python.h"
#include <stdlib.h>
#include <stdio.h>

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

void parseTreeToPython(B_TREE t)
{
    if (t == NULL)
        return;

    if (strcmp(labels[(t->nodeIdentifier)], "COMMENT_BLOCK") == 0)
    {
        printf("written for nodeIdentifier: %s\n", labels[(t->nodeIdentifier)]);
        writeStringInPythonFile("#");
        writeStringInPythonFile(t->val.v.s);
    }
    else if (strcmp(labels[(t->nodeIdentifier)], "ADDITION") == 0)
    {
        printf("written for nodeIdentifier: %s\n", labels[(t->nodeIdentifier)]);
        parseTreeToPython(t->first);
        writeStringInPythonFile(" + ");
        parseTreeToPython(t->second);
    }
    else if (strcmp(labels[(t->nodeIdentifier)], "SUPERIOR") == 0)
    {
        printf("written for nodeIdentifier: %s\n", labels[(t->nodeIdentifier)]);
        parseTreeToPython(t->first);
        writeStringInPythonFile(" > ");
        parseTreeToPython(t->second);
    }
    else if (strcmp(labels[(t->nodeIdentifier)], "INFERIOR") == 0)
    {
        printf("written for nodeIdentifier: %s\n", labels[(t->nodeIdentifier)]);
        parseTreeToPython(t->first);
        writeStringInPythonFile(" > ");
        parseTreeToPython(t->second);
    }
    else if (strcmp(labels[(t->nodeIdentifier)], "SUPERIOR_EQUAL") == 0)
    {
        printf("written for nodeIdentifier: %s\n", labels[(t->nodeIdentifier)]);
        parseTreeToPython(t->first);
        writeStringInPythonFile(" >= ");
        parseTreeToPython(t->second);
    }
    else if (strcmp(labels[(t->nodeIdentifier)], "INFERIOR_EQUAL") == 0)
    {
        printf("written for nodeIdentifier: %s\n", labels[(t->nodeIdentifier)]);
        parseTreeToPython(t->first);
        writeStringInPythonFile(" <= ");
        parseTreeToPython(t->second);
    }
    else if (strcmp(labels[(t->nodeIdentifier)], "NOT_EQUAL") == 0)
    {
        printf("written for nodeIdentifier: %s\n", labels[(t->nodeIdentifier)]);
        parseTreeToPython(t->first);
        writeStringInPythonFile(" != ");
        parseTreeToPython(t->second);
    }
    else if (strcmp(labels[(t->nodeIdentifier)], "CONSTANT_EXPR") == 0)
    {
        printf("written for nodeIdentifier: %s\n", labels[(t->nodeIdentifier)]);
        parseTreeToPython(t->first);
    }
    else if (strcmp(labels[(t->nodeIdentifier)], "CONSTANT") == 0)
    {
        printf("written for nodeIdentifier: %s\n", labels[(t->nodeIdentifier)]);
        if (strcmp(t->val.use, "int") == 0)
            writeIntInPythonFile(t->val.v.i);
    }
    else if (strcmp(labels[(t->nodeIdentifier)], "DECLARATION") == 0)
    {
        printf("written for nodeIdentifier: %s\n", labels[(t->nodeIdentifier)]);
        writeStringInPythonFile(t->first->first->val.v.s);
        writeStringInPythonFile(" = ");
        writeStringInPythonFile("None");
        writeStringInPythonFile("\n");
    }
    else if (strcmp(labels[(t->nodeIdentifier)], "ASSIGNATION") == 0)
    {
        printf("written for nodeIdentifier: %s\n", labels[(t->nodeIdentifier)]);
        parseTreeToPython(t->first);
        writeStringInPythonFile(" = ");
        parseTreeToPython(t->second);
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
        //IF
        writeStringInPythonFile("if ");
        //ID
        writeStringInPythonFile(t->first->first->first->val.v.s);
        //Boolean operator
        findBooleanOperator(labels[(t->first->nodeIdentifier)]);
        //TODO CONSTANT
        findBasicDataType(t->first->second->first);

        writeStringInPythonFile(":\n\t");
        //printf("CST: %s\n",labels[(t->first->second->first->nodeIdentifier)]);
        //writeStringInPythonFile(t->first->second->first->val.v.s);
    }
    else if (strcmp(labels[(t->nodeIdentifier)], "WHILE_LOOP") == 0)
    {
        printf("written for nodeIdentifier: %s\n", labels[(t->nodeIdentifier)]);
        // while
        writeStringInPythonFile("while ");
        parseTreeToPython(t->first);
        writeStringInPythonFile(":\n\t");
        parseTreeToPython(t->second);
    }
    else
    {
        printf("nothing written for nodeIdentifier: %s\n", labels[(t->nodeIdentifier)]);
        parseTreeToPython(t->first);
        parseTreeToPython(t->second);
        parseTreeToPython(t->third);
        parseTreeToPython(t->fourth);
    }
}



