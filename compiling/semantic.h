#include "stdio.h"
#include <stdlib.h>
#include <string.h>

typedef enum
{
    METHOD,
    VARIABLE,
    CLASS,
} symbol_type;

typedef struct scope{
    int parent;
    int fils [100];
    int nbFils;
}scope_tree;



typedef struct 
{
    char *name;
    symbol_type type;
    int scope;
    int isInit;
    int isUsed;
    int nbArgs;
} node;
