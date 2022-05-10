%{
#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include "semantic.c"
extern int nbLigne;

int err= 0;
// the variable nom will stock the name of an identifier
char nom [256];
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
                            verifyCalledMethods();
                            displayWarnings();
                            printSymbolTable();
                           printUsedMethods();
                        }}

mainClass : kw_class identifier  openBraces kw_public kw_static kw_void kw_main openParentheses kw_String openSquareBrackets closeSquareBrackets
            identifier closeParentheses openBraces varsDeclaration statement closeBraces closeBraces
          | error identifier openBraces kw_public kw_static kw_void kw_main openParentheses kw_String openSquareBrackets closeSquareBrackets
            identifier closeParentheses openBraces statement closeBraces closeBraces {yyerror ("le mot cle 'class' est manquant"); }
          | kw_class error openBraces kw_public kw_static kw_void kw_main openParentheses kw_String openSquareBrackets closeSquareBrackets
            identifier closeParentheses openBraces statement closeBraces closeBraces {yyerror (" le nom du classe est manquant"); }
	  | kw_class identifier error kw_public kw_static kw_void kw_main openParentheses kw_String openSquareBrackets closeSquareBrackets
            identifier closeParentheses openBraces statement closeBraces closeBraces {yyerror ("'{' expected"); }
          | kw_class identifier openBraces error kw_static kw_void kw_main openParentheses kw_String openSquareBrackets closeSquareBrackets
            identifier closeParentheses openBraces statement closeBraces closeBraces {yyerror ("le mot cle 'public' est manquant"); }
          | kw_class identifier openBraces kw_public error kw_void kw_main openParentheses kw_String openSquareBrackets closeSquareBrackets
            identifier closeParentheses openBraces statement closeBraces closeBraces {yyerror ("le mot cle 'static' est manquant"); }
          | kw_class identifier openBraces kw_public kw_static error kw_main openParentheses error openSquareBrackets closeSquareBrackets
            identifier closeParentheses openBraces statement closeBraces closeBraces {yyerror ("le type de la methode est manquant"); }
 	  | kw_class identifier openBraces kw_public kw_static kw_void error openParentheses kw_String openSquareBrackets closeSquareBrackets
            identifier closeParentheses openBraces statement closeBraces closeBraces {yyerror ("la methode main est introuvable"); }
         | kw_class identifier openBraces kw_public kw_static kw_void kw_main error kw_String openSquareBrackets closeSquareBrackets
            identifier closeParentheses openBraces statement closeBraces closeBraces {yyerror ("'(' expected"); }
          | kw_class identifier openBraces kw_public kw_static kw_void kw_main openParentheses kw_String error closeSquareBrackets
            identifier closeParentheses openBraces statement closeBraces closeBraces {yyerror ("'[' expected"); }
          | kw_class identifier openBraces kw_public kw_static kw_void kw_main openParentheses kw_String openSquareBrackets error
            identifier closeParentheses openBraces statement closeBraces closeBraces {yyerror ("']' expected"); YYABORT }
          | kw_class identifier openBraces kw_public kw_static kw_void kw_main openParentheses kw_String openSquareBrackets closeSquareBrackets
            error closeParentheses openBraces statement closeBraces closeBraces {yyerror ("nom du parametre manquant"); }
          | kw_class identifier openBraces kw_public kw_static kw_void kw_main openParentheses error openSquareBrackets closeSquareBrackets
            identifier closeParentheses openBraces statement closeBraces closeBraces {yyerror ("le type du parametre manquant"); }
          | kw_class identifier openBraces kw_public kw_static kw_void kw_main openParentheses kw_String openSquareBrackets closeSquareBrackets
            identifier error openBraces statement closeBraces closeBraces {yyerror ("')' expected"); }
          | kw_class identifier openBraces kw_public kw_static kw_void kw_main openParentheses kw_String openSquareBrackets closeSquareBrackets
            identifier closeParentheses error statement closeBraces closeBraces {yyerror ("'{' expected"); }
          | kw_class identifier openBraces kw_public kw_static kw_void kw_main openParentheses kw_String openSquareBrackets closeSquareBrackets
            identifier closeParentheses openBraces error closeBraces closeBraces {yyerror ("la fonction main est vide"); }
	  | kw_class identifier openBraces kw_public kw_static kw_void kw_main openParentheses kw_String openSquareBrackets closeSquareBrackets
            identifier closeParentheses openBraces statement error closeBraces {yyerror ("'}' expected"); }
          | kw_class identifier openBraces kw_public kw_static kw_void kw_main openParentheses kw_String openSquareBrackets closeSquareBrackets
            identifier closeParentheses openBraces statement closeBraces error {yyerror ("'}' expected"); }


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
methodDeclaration:  kw_public typeDeclaration identifier {{strcpy(methodName,nom);}} openParentheses   
                   functionVars closeParentheses  openBraces varsDeclaration   statement kw_return  expression Semicolon closeBraces methodDeclaration
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
            openBraces varsDeclaration closeBraces|
            kw_if openParentheses expression closeParentheses statement kw_else statement |
            kw_while openParentheses expression closeParentheses statement |
            kw_print openParentheses expression closeParentheses Semicolon statement|
            identifier  affectation {{
            // printf("Hello world\n");
              isIdDeclared(nom,nbLigne);
              markAsInitialisated(nom);
            }} expression Semicolon statement|
            identifier openSquareBrackets expression closeSquareBrackets affectation expression Semicolon|
            error openSquareBrackets expression closeSquareBrackets affectation expression Semicolon {yyerror ("invalid expression"); } |
            identifier error expression closeSquareBrackets affectation expression Semicolon {yyerror ("'[' expected"); } |
            identifier openSquareBrackets expression error affectation expression Semicolon {yyerror ("']' expected"); } |
            identifier openSquareBrackets expression closeSquareBrackets error expression Semicolon {yyerror ("'=' expected"); } |
            identifier openSquareBrackets expression closeSquareBrackets affectation expression error {yyerror ("';' expected"); } |

expression : identifier {{
            // printf("Hello world\n");
              isIdDeclared(nom,nbLigne);
              markAsUsed(nom);
            }}  operator identifier {{
             //printf("Hello world\n");
              isIdDeclared(nom,nbLigne);
              markAsUsed(nom);
            }}  
            |
             expression openSquareBrackets expression closeSquareBrackets 
            |
             identifier  {{
             //printf("Hello world\n");
              isIdDeclared(nom,nbLigne);
              markAsUsed(nom);
            }}  operator integerLiteral 
            |
             integerLiteral operator identifier  {{
             //printf("Hello world\n");
              isIdDeclared(nom,nbLigne);
            }} 
            |
             expression error expression closeSquareBrackets {yyerror ("'[' expected"); } |
             expression openSquareBrackets expression error {yyerror ("']' expected"); } |
             expression dot kw_length |
             expression dot identifier {{ 
               saveMethod(nom,nbLigne);
             }}openParentheses expression {{nbCalledArgs++;}} anotherExpression closeParentheses {{
                                          //printf("Number of args: %d\n",nbCalledArgs);
                                          usedMethods[nbUsedMethods-1].nbArgs=nbCalledArgs;
                                          nbCalledArgs=0;
                                          }} |
             integerLiteral  |
             integerLiteral error {yyerror ("';' expected"); } |
             booleanLiteral  |
             booleanLiteral error {yyerror ("';' expected"); } |
             identifier |
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
  
     