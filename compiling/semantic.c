#include "semantic.h"
#include <stdio.h>
#include <stdlib.h>

scope_tree scope[100];
int maxScope = 0;
int currentScope = 0;
node identifiers[500];
int nbIdentifiers=0;
void sayHello(char *line)
{
    printf("\nHello %s\n", line);
}
void init()
{
    scope[0].nbFils = 0;
    scope[0].parent = -1;
}
void enterScope()
{
    maxScope++;
    scope[currentScope].nbFils = maxScope;
    scope[maxScope].parent = currentScope;
    currentScope = maxScope;
    printf("Current scope = %d\n", currentScope);
}

void exitScope()
{
    currentScope = scope[currentScope].parent;
    printf("Current scope = %d\n", currentScope);
}

int searchIdentifier(char* name){
    for (int i =0;i<)
}
void addVariable(){

}
