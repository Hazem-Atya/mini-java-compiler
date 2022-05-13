#include "semantic.h"
#include <stdio.h>
#include <stdlib.h>
#include <string.h>
scope_tree scope[100];
int maxScope = 0;
int currentScope = 0;
node symbolTable[500];
int nbIdentifiers = 0;

typedef struct
{
    char methodName[50];
    int lineNumber;
    int nbArgs;
} UsedMethod;

UsedMethod usedMethods[100];
int nbUsedMethods = 0;
void sayHello(char *line)
{
    printf("\nHello %s\n", line);
}
void printSymbolTable()
{
    printf("\n\n\n------------------------------------------------------------\n");
    printf("                      Symbol table                          \n");
    printf("------------------------------------------------------------\n");
    printf("%5s %10s %10s %10s %10s\n", "Index", "Name", "Scope", "Type", "Is init");

    for (int i = 0; i < nbIdentifiers; i++)
    {
        printf("%5d %10s %10d %10s %10d\n", i, symbolTable[i].name,
               symbolTable[i].scope, TYPES[symbolTable[i].type], symbolTable[i].isInit);
    }
    printf("------------------------------------------------------------\n\n\n");
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
    //  printf("Current scope = %d\n", currentScope);
}

void exitScope()
{
    currentScope = scope[currentScope].parent;
    // printf("Current scope = %d\n", currentScope);
}

int searchIdInCurrentScope(char name[], int isClass)
{
    for (int i = 0; i < nbIdentifiers; i++)
    {
        if (!isClass && (symbolTable[i].scope == currentScope) && (!strcmp(symbolTable[i].name, name)))
        {
            // printf("----------------------error-------------------\n");
            // printSymbolTable();
            // printf("----------------------error-------------------\n");
            return 1;
        }
        if (isClass && (symbolTable[i].type == CLASS) && (!strcmp(symbolTable[i].name, name)))
        {
            // printf("----------------------error-------------------\n");
            // printSymbolTable();
            // printf("----------------------error-------------------\n");
            return 1;
        }
    }
    return 0;
}
void addVariable(char varName[], int line, int isMethodArg)
{
    if (searchIdInCurrentScope(varName, 0))
    {
        printf("Error on line %d: Identifier '%s' already defined in this scope\n", line, varName);
        exit(0);
    }

    strcpy(symbolTable[nbIdentifiers].name, varName);
    symbolTable[nbIdentifiers].isInit = 0;
    symbolTable[nbIdentifiers].isUsed = 0;
    symbolTable[nbIdentifiers].nbArgs = 0;
    symbolTable[nbIdentifiers].line = line;
    symbolTable[nbIdentifiers].type = VARIABLE;
    if (!isMethodArg)
    {
        symbolTable[nbIdentifiers].scope = currentScope;
        symbolTable[nbIdentifiers].isMethodArg = 0;
    }

    else
    {
        symbolTable[nbIdentifiers].scope = maxScope + 1;
        symbolTable[nbIdentifiers].isMethodArg = 1;
    }

    // printf("Nom in here  is:%s\n", symbolTable[nbIdentifiers].name);

    nbIdentifiers++;
    // printf("--------------------------------------------\n");
    // printSymbolTable();
    // printf("--------------------------------------------\n");
}

void addClass(char varName[], int line)
{
    if (searchIdInCurrentScope(varName, 1))
    {
        printf("Error on line %d: class '%s' already defined\n", line, varName);
        exit(0);
    }

    strcpy(symbolTable[nbIdentifiers].name, varName);
    symbolTable[nbIdentifiers].isInit = 0;
    symbolTable[nbIdentifiers].isUsed = 0;
    symbolTable[nbIdentifiers].nbArgs = 0;
    symbolTable[nbIdentifiers].type = CLASS;
    symbolTable[nbIdentifiers].scope = currentScope;
    nbIdentifiers++;
}
void addMethod(char methodName[], char *args[], int nbArgs, int nbLine)
{
    strcpy(symbolTable[nbIdentifiers].name, methodName);
    symbolTable[nbIdentifiers].isInit = 0;
    symbolTable[nbIdentifiers].isUsed = 0;
    symbolTable[nbIdentifiers].nbArgs = nbArgs;
    symbolTable[nbIdentifiers].type = METHOD;
    symbolTable[nbIdentifiers].scope = currentScope;
    nbIdentifiers++;
    for (int i = 0; i < nbArgs; i++)
    {
        addVariable(args[i], nbLine, 1);
    }
}

void saveMethod(char methodName[], int nbLine)
{
    usedMethods[nbUsedMethods].lineNumber = nbLine;
    strcpy(usedMethods[nbUsedMethods].methodName, methodName);
    nbUsedMethods++;
}

void printUsedMethods()
{
    for (int i = 0; i < nbUsedMethods; i++)
    {
        printf("Method name: %s\n", usedMethods[i].methodName);
        printf("line: %d\n", usedMethods[i].lineNumber);
        printf("nbArgs: %d\n", usedMethods[i].nbArgs);
    }
}

int verifyOneMethod(char methodName[], int nbArgs, int line)
{

    for (int i = 0; i < nbIdentifiers; i++)
    {

        if (symbolTable[i].type == METHOD)
        {
            if ((!strcmp(symbolTable[i].name, methodName)))
            {
                if (symbolTable[i].nbArgs != nbArgs)
                {
                    printf("Line %d: method '%s' defined with %d arguments but called with %d arguments\n",
                           line, methodName, symbolTable[i].nbArgs, nbArgs);
                    exit(0);
                }
                return 1;
            }
        }
    }
    printf("Line %d: method '%s' called but not declared\n", line, methodName);
    exit(0);
    return 0;
}

int verifyCalledMethods()
{
    for (int j = 0; j < nbUsedMethods; j++)
    {

        verifyOneMethod(usedMethods[j].methodName, usedMethods[j].nbArgs, usedMethods[j].lineNumber);
    }
}

// this function gets to params that represents two scopes,
// if the second scope is a parent of the fisrt scope => return 1
// else => return 0
int isItMyParentScope(int childScope, int parentScope)
{
    if (childScope == parentScope)
    {
        return 1;
    }
    while (childScope != 0)
    {
        if (scope[childScope].parent == parentScope)
        {
            return 1;
        }
        childScope = scope[childScope].parent;
    }
}

int isIdDeclared(char varName[], int line)
{
    for (int i = 0; i < nbIdentifiers; i++)
    {
        if ((isItMyParentScope(currentScope, symbolTable[i].scope)) && (!strcmp(symbolTable[i].name, varName)))
        {
            return 1;
        }
    }
    printf("Line %d: Identifier %s used but not declared\n", line, varName);
    exit(0);
    return 0;
}

int markVarInitialised(char varName[], int currScope)
{

    for (int i = 0; i < nbIdentifiers; i++)
    {
        if ((strcmp(symbolTable[i].name, varName) == 0) && (symbolTable[i].scope == currScope))
        {
            symbolTable[i].isInit = 1;
            return 1;
        }
    }
    return 0;
}
int markAsInitialisated(char varName[])
{
    int currScope = currentScope;
    while (!markVarInitialised(varName, currScope) && currScope != 0)
    {
        currScope = scope[currentScope].parent;
    }
    // printf("Error occured! variable does not exist");
    // exit(0);
}
int markVarUsed(char varName[], int currScope)
{
    for (int i = 0; i < nbIdentifiers; i++)
    {
        if ((strcmp(symbolTable[i].name, varName) == 0) && (symbolTable[i].scope == currScope))
        {
            symbolTable[i].isUsed = 1;
            return 1;
        }
    }
    return 0;
}
void markAsUsed(char varName[])
{
    int currScope = currentScope;
    while (!markVarUsed(varName, currScope) && currScope != 0)
    {
        currScope = scope[currentScope].parent;
    }
}
int displayWarnings()
{
    for (int i = 0; i < nbIdentifiers; i++)
    {
        if ((symbolTable[i].type == VARIABLE) && (symbolTable[i].isInit == 0) && (symbolTable[i].isMethodArg == 0))
        {
            printf("Warning line %d: variable %s declared but not initialisated\n",
                   symbolTable[i].line, symbolTable[i].name);
        }
        else if ((symbolTable[i].type == VARIABLE) && (symbolTable[i].isUsed == 0))
        {
            printf("Warning line %d: variable %s not used\n",
                   symbolTable[i].line, symbolTable[i].name);
        }
    }
}

/*-----------------
the following functions were created for code generation purposes
--------------------*/

// returns the index of an identifier
int findIdentifier(char idName[])
{
    for (int i = 0; i < nbIdentifiers; i++)
    {
        if ((strcmp(symbolTable[i].name, idName) == 0) && (isItMyParentScope(currentScope, symbolTable[i].scope)))
        {
            return i;
        }
    }
    //printf("IDENTIFIER %s NOT DECLARED\n", idName);
    //exit(0);
    return -1;
}