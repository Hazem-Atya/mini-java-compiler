%{
#include <stdio.h>
#include <stdlib.h>
#include <string.h>

extern int nbLigne;

int err= 0;
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
                                                           
program	  : mainClass classDeclaration

mainClass : kw_class identifier openBraces kw_public kw_static kw_void kw_main openParentheses kw_String openSquareBrackets closeSquareBrackets
            identifier closeParentheses openBraces statement closeBraces closeBraces
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
            identifier closeParentheses openBraces statement closeBraces closeBraces {yyerror ("']' expected"); }
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


classDeclaration: kw_class identifier parentClass openBraces varsDeclaration 
                  methodDeclaration closeBraces classDeclaration
                | error identifier parentClass openBraces varsDeclaration
                  methodDeclaration closeBraces classDeclaration {yyerror ("'class' expected"); }
                |

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
	err = 1;
	if(msg != "syntax error")
	fprintf(stderr, "erreur ligne %d : %s\n", nbLigne, msg);
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
     if(err==0)
     printf("Code compiled successfully");

	return(1);
}
  
     