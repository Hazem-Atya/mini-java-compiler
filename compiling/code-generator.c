#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include "semantic.c"

typedef struct
{
    char code_op[50];
    int operand;
    char functionName[50];
} CODE_ENTRY;

CODE_ENTRY codeTabInt[100];
int nbCodes = 0;




void addCode(char code_op[], int op, char fct[])
{
    strcpy(codeTabInt[nbCodes].code_op, code_op);
    codeTabInt[nbCodes].operand = op;
    strcpy(codeTabInt[nbCodes].functionName, fct);
    nbCodes++;
}
void printCodeTab()
{
    printf("%5s %10s %10s %10s\n", "Nb", "Op_Code", "Operand", "Function");
    printf("---------------------------------------------\n");
    for (int i = 0; i < nbCodes; i++)
    {
        printf("%5d %10s %10d %10s\n", i, codeTabInt[i].code_op, codeTabInt[i].operand, codeTabInt[i].functionName);
    }
    printf("---------------------------------------------\n\n\n");
}


void addOperator(char operSymbol[])
{
    if (!strcmp(operSymbol, "*"))
    {
        addCode("MUL", -1, "");
    }
    else if (!strcmp(operSymbol, "+"))
    {
        addCode("ADD", -1, "");
    }
    else if (!strcmp(operSymbol, "-"))
    {
        addCode("SUB", -1, "");
    }
    else if (!strcmp(operSymbol, "<"))
    {
        addCode("INF", -1, "");
    }
    else if (!strcmp(operSymbol, "=="))
    {
        addCode("EGAL", -1, "");
    }
    else if (!strcmp(operSymbol, "!="))
    {
        addCode("DIF", -1, "");
    }
}