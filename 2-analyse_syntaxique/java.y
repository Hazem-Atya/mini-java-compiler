%{
#include <stdio.h>
#include <stdlib.h>
#include <string.h>

extern int nbLigne;


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
                                                           
program	     : mainClass classDeclaration  
mainClass : kw_class identifier openBraces kw_public kw_static 
            kw_void kw_main openParentheses kw_String openSquareBrackets closeSquareBrackets  
            identifier closeParentheses openBraces statement closeBraces closeBraces

classDeclaration: kw_class identifier parentClass openBraces varsDeclaration 
                  methodDeclaration closeBraces classDeclaration |

parentClass: kw_extends identifier | 

identifierOrNumber: identifier | integerLiteral
varsDeclaration: typeDeclaration identifier Semicolon varsDeclaration | 
                typeDeclaration identifier affectation identifierOrNumber Semicolon varsDeclaration |
typeDeclaration : _type | kw_String
methodDeclaration: kw_public typeDeclaration identifier openParentheses functionVars 
                   closeParentheses openBraces statement 
                   kw_return  expression Semicolon closeBraces methodDeclaration |
                   kw_public typeDeclaration identifier openParentheses  
                   closeParentheses openBraces  
                   closeBraces methodDeclaration  |


                   
functionVars: functionVariables |
functionVariables :  typeDeclaration identifier | typeDeclaration identifier comma functionVariables 

statement:  
            varsDeclaration | 
            openBraces statement closeBraces |
            kw_if openParentheses expression closeParentheses statement kw_else statement |
            kw_while openParentheses expression closeParentheses statement |
            kw_print openParentheses expression closeParentheses Semicolon |
            identifier affectation expression Semicolon |
            identifier openSquareBrackets expression closeSquareBrackets affectation expression Semicolon|

expression : expression operator expression|
             expression openSquareBrackets expression closeSquareBrackets |
             expression dot kw_length |
             expression dot identifier openParentheses expression anotherExpression  |
             integerLiteral Semicolon |
             booleanLiteral Semicolon |
             identifier |
             kw_this |
             kw_new identifier openParentheses closeParentheses |
             notOperator expression |
             openParentheses expression closeParentheses  | 

anotherExpression: comma expression anotherExpression | 

%% 

int yyerror(char const *msg) {
       
	
	fprintf(stderr, "erreur ligne %d : %s\n", nbLigne, msg);
	return 0;
	
	
}

extern FILE *yyin;

main()
{
 yyparse();
}
int yywrap()
{
     printf("Code compiled successfully");

	return(1);
}
  
     