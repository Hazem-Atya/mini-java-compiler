#include "stdio.h"
#include <stdlib.h>
#include <string.h>

char *TYPES[] = {"method", "variable", "class"};
typedef enum
{
    METHOD,
    VARIABLE,
    CLASS,
} symbol_type;

typedef struct scope
{
    int parent;
    int fils[100];
    int nbFils;
} scope_tree;

typedef struct
{
    char name[100];
    symbol_type type;
    int scope;
    int isInit; // =1 if the identifier is initialisated and 0 otherwise
    int isUsed; // =  =1 if the identifier is used and 0 otherwise
    int nbArgs; // contains the number of arguments if the identifier is a method
    int line;
    int isMethodArg;
} node;
