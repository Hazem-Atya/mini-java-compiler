%{
#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include "code-generator.c"
extern int nbLigne;

int err= 0;
// the variable nom will stock the name of an identifier
char nom [256];
int intValue;
char operSymbol [10];
int index;
int codeTabIndex;
int beginOfWhile;
int calledMethodIndex;
int backToMainIndex;
char calledMethodName [50];
//------------- THIS BLOCK IS FOR METHODS HANDELING---------------------
char methodName [50];
char * mehtodArgs [50];
int nbArgs=0;
int nbCalledArgs=0;
//----------------
int yyerror(char const * msg);	
int yylex();

%}
%token  kw_class
%token  kw_public 
%token  kw_static 
%token  kw_void
%token  kw_main
%token  kw_extends
%token  kw_return 
%token  kw_if
%token  kw_else
%token  kw_while
%token  kw_print
%token  kw_this
%token  kw_new
%token  kw_length
%token  _type
%token  kw_String
%token  openParentheses
%token  closeParentheses
%token  openSquareBrackets
%token  closeSquareBrackets
%token  openBraces
%token  closeBraces
%token  operator
%token  affectation
%token  notOperator
%token  dot
%token  Semicolon
%token  comma
%token  doubleQuote
%token  simpleQuote
%token  booleanLiteral
%token  integerLiteral
%token  identifier


%start program
%%
                                                           
program	  : {{init();}} mainClass classDeclaration  
                        {{  
                           //printCodeTab();
                            verifyCalledMethods();
                            displayWarnings();
                            printSymbolTable();
                            printCodeTab();
                           //printUsedMethods();
                        }}

mainClass : kw_class identifier  openBraces kw_public kw_static kw_void kw_main openParentheses kw_String openSquareBrackets closeSquareBrackets
            identifier closeParentheses openBraces {  addCode("ENTREE",-1,"main");  } 
            varsDeclaration statement closeBraces closeBraces  
            {
              addCode("SORTIE",-1,"main");
            }
           |kw_class identifier  openBraces kw_public kw_static kw_void kw_main openParentheses kw_String openSquareBrackets closeSquareBrackets
             error closeParentheses openBraces varsDeclaration statement closeBraces closeBraces {yyerror ("Main method args needed"); }


classHead: kw_class identifier  {{
                                  addClass(nom,nbLigne);
                                  }}  parentClass
classDeclaration:  classHead openBraces  varsDeclaration 
                  methodDeclaration closeBraces classDeclaration
                | error identifier parentClass openBraces varsDeclaration
                  methodDeclaration closeBraces classDeclaration {yyerror ("'class' expected"); }
                | kw_class error parentClass openBraces varsDeclaration
                  methodDeclaration closeBraces classDeclaration {yyerror ("class name expected"); }
                | kw_class identifier parentClass error varsDeclaration
                  methodDeclaration closeBraces classDeclaration {yyerror ("'{' expected"); }
                | kw_class identifier parentClass openBraces varsDeclaration
                  methodDeclaration error classDeclaration {yyerror ("'}' expected"); }
                |

parentClass: kw_extends identifier
	   | error identifier {yyerror ("'extends' expected"); }
	   | kw_extends error {yyerror ("invalid Parent class name "); }
	   |

identifierOrNumber: identifier | integerLiteral

varsDeclaration: typeDeclaration identifier Semicolon {{
  
                  addVariable(nom,nbLigne,0);
                  }} varsDeclaration 
          | typeDeclaration openSquareBrackets closeSquareBrackets identifier Semicolon varsDeclaration
	       | typeDeclaration identifier affectation identifierOrNumber Semicolon varsDeclaration
	       | error identifier Semicolon varsDeclaration {yyerror ("invalid type declaration "); }
	       | typeDeclaration error Semicolon varsDeclaration {yyerror ("invalid identifier declaration "); }
	       | typeDeclaration identifier error varsDeclaration {yyerror (" ';' expected "); }
	       | error identifier affectation identifierOrNumber Semicolon varsDeclaration {yyerror ("invalid type declaration "); }
	       | typeDeclaration error affectation identifierOrNumber Semicolon varsDeclaration {yyerror ("invalid identifier declaration "); }
	       | typeDeclaration identifier error identifierOrNumber Semicolon varsDeclaration{yyerror ("'=' expected "); }
	       | typeDeclaration identifier affectation error Semicolon varsDeclaration {yyerror ("invalid identifier affectation "); }
	       | typeDeclaration identifier affectation identifierOrNumber error varsDeclaration {yyerror ("';' expected "); }
	       |
typeDeclaration : _type | kw_String
methodHead:  
methodDeclaration:  kw_public typeDeclaration identifier 
                    {{
                        codeTabInt[calledMethodIndex].operand = nbCodes;
                        strcpy(methodName,nom);
                        addCode("ENTREE",-1,methodName);
                    }} 
                    openParentheses  functionVars closeParentheses  openBraces varsDeclaration   statement kw_return  expression Semicolon closeBraces
                     {
                      addCode("SORTIE",-1,methodName);
                      addCode("RETOUR",backToMainIndex,"");
                     } methodDeclaration
                  
                  |
                   kw_public error identifier  openParentheses   
                   functionVars closeParentheses  openBraces varsDeclaration   statement kw_return  expression Semicolon closeBraces methodDeclaration
                    {yyerror ("Missing return type"); }
                  | 





                   
functionVars: functionVariables |
functionVariables :  typeDeclaration identifier 
                    {{
                    
                          char aux [50];
                          strcpy(aux,nom);
                          mehtodArgs[nbArgs]=(char*)malloc(50*sizeof(char));
                          memcpy(mehtodArgs[nbArgs],aux,strlen(aux)+1);
                          nbArgs ++;
                          addMethod(methodName,mehtodArgs,nbArgs,nbLigne);
                          nbArgs=0;
                    
                    }}
                    | typeDeclaration identifier 
                    {{
                          char aux [50];
                          strcpy(aux,nom);
                          mehtodArgs[nbArgs]=(char*)malloc(50*sizeof(char));
                          memcpy(mehtodArgs[nbArgs],aux,strlen(aux)+1);
                          nbArgs ++;
                    }}
                      comma functionVariables 


statement:  
            openBraces statement closeBraces statement|
            openBraces varsDeclaration closeBraces statement|
            kw_if openParentheses expression  closeParentheses
            {
              addOperator(operSymbol);
              addCode("SIFAUX",9999,"");
              codeTabIndex=nbCodes-1;
            }
              statement kw_else
              {
              addCode("SAUT",3333,"");
              codeTabInt[codeTabIndex].operand=nbCodes;
              codeTabIndex=nbCodes-1;
              }
               openBraces statement closeBraces {
              codeTabInt[codeTabIndex].operand=nbCodes;
               }   statement|
            kw_while openParentheses
            {
              beginOfWhile=nbCodes;
            }
             expression closeParentheses
            {
              addOperator(operSymbol);
              addCode("TANTQUEFAUX",2000,"");
              codeTabIndex=nbCodes-1;
            }
            openBraces statement closeBraces 
            {
              addCode("TANTQUE",2000,"");
              codeTabInt[codeTabIndex].operand=nbCodes;
              codeTabInt[nbCodes-1].operand=beginOfWhile;
            }
            statement |
            kw_print openParentheses  expression  closeParentheses Semicolon statement|
            kw_print openParentheses expression error Semicolon statement 
            {yyerror ("Missing close parentheses"); }
            |
          
            identifier {
              index= findIdentifier(nom);
            }  affectation {{
            // printf("Hello world\n");
              isIdDeclared(nom,nbLigne);
              markAsInitialisated(nom);
            }} expression Semicolon  
            { 
              if (!strcmp(operSymbol,"*")){
                addCode("MUL",-1,"");                
              }
              else if (!strcmp(operSymbol,"+")){
                addCode("ADD",-1,""); 
              }
              else if (!strcmp(operSymbol,"-")){
                addCode("SUB",-1,""); 

              }
              addCode("STORE ",index,"");
            } 
            statement|
            identifier  error  expression Semicolon statement  {yyerror ("Missing affectation"); }|
            identifier openSquareBrackets expression closeSquareBrackets affectation expression Semicolon|
            error openSquareBrackets expression closeSquareBrackets affectation expression Semicolon {yyerror ("invalid expression"); } |
            identifier error expression closeSquareBrackets affectation expression Semicolon {yyerror ("'[' expected"); } |
            identifier openSquareBrackets expression error affectation expression Semicolon {yyerror ("']' expected"); } |
            identifier openSquareBrackets expression closeSquareBrackets error expression Semicolon {yyerror ("'=' expected"); } |
            identifier openSquareBrackets expression closeSquareBrackets affectation expression error {yyerror ("';' expected"); } |

expression : identifier  {{
            // printf("Hello world\n");
              isIdDeclared(nom,nbLigne);
              markAsUsed(nom);
              int index =  findIdentifier(nom);
              addCode("LDV",index,"");
            }}  operator identifier {{
             //printf("Hello world\n");
              isIdDeclared(nom,nbLigne);
              markAsUsed(nom);
              int index =  findIdentifier(nom);
              addCode("LDV",index,"");
            }}  
            |
             expression openSquareBrackets expression closeSquareBrackets 
            |
             identifier  {{
             //printf("Hello world\n");
              isIdDeclared(nom,nbLigne);
              markAsUsed(nom);
              int index =  findIdentifier(nom);
              addCode("LDV",index,"");
            }}  operator integerLiteral {
              addCode("LDC",intValue,"");
            }
            |
             integerLiteral {
                addCode("LDC",intValue,"");
             } operator identifier  {{
             //printf("Hello world\n");
              isIdDeclared(nom,nbLigne);
               int index =  findIdentifier(nom);
              addCode("LDV",index,"");
            }} 
            |
             expression error expression closeSquareBrackets {yyerror ("'[' expected"); } |
             expression openSquareBrackets expression error {yyerror ("']' expected"); } |
             expression dot kw_length |
             expression dot identifier {{ 
               saveMethod(nom,nbLigne);
              calledMethodIndex=nbCodes;
              strcpy(calledMethodName,nom);
              addCode("APPEL",11111,"");
              backToMainIndex=nbCodes;
             }}openParentheses expression {{nbCalledArgs++;}} anotherExpression closeParentheses {{
                                          //printf("Number of args: %d\n",nbCalledArgs);
                                          usedMethods[nbUsedMethods-1].nbArgs=nbCalledArgs;
                                          nbCalledArgs=0;
                                          }} |
             integerLiteral 
              {
                index= findIdentifier(nom);
                addCode("LDC",intValue,"");
              }             
            |
             integerLiteral error {yyerror ("';' expected"); } |
             booleanLiteral  |
             booleanLiteral error {yyerror ("';' expected"); } |
             identifier 
              {
                index= findIdentifier(nom);
                addCode("LDV",index,"");
              } 
            |
             kw_this |
             kw_new identifier openParentheses closeParentheses |
             notOperator expression |
             openParentheses expression closeParentheses  |

anotherExpression: comma expression {{nbCalledArgs++;}} anotherExpression |
		  

%%

int yyerror(char const *msg) {
	err = 1;
	if(msg == "syntax error")
	  {
     fprintf(stderr, "\nerreur ligne %d :", nbLigne );
    }
  else
	{
  fprintf(stderr, msg);
  exit(0);
  }
	return 0;
}

extern FILE *yyin;

int main()
{
 yyparse();
 return 1;
}
int yywrap()
{
//     if(err==0)
  //   printf("Code compiled successfully\n");

	return(1);
}
  
     