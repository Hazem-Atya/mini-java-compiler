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


classDeclaration: kw_class identifier parentClass openBraces varsDeclaration 
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

varsDeclaration: typeDeclaration identifier Semicolon varsDeclaration
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
methodDeclaration: kw_public typeDeclaration identifier openParentheses functionVars 
                   closeParentheses openBraces statement kw_return  expression Semicolon closeBraces methodDeclaration
                 | kw_public typeDeclaration identifier openParentheses  closeParentheses openBraces closeBraces methodDeclaration
                 | error typeDeclaration identifier openParentheses functionVars
                   closeParentheses openBraces statement kw_return  expression Semicolon closeBraces methodDeclaration
                   {yyerror ("'public' expected "); }
                 | kw_public error identifier openParentheses functionVars
                   closeParentheses openBraces statement kw_return  expression Semicolon closeBraces methodDeclaration
                   {yyerror ("invalid type declaration "); }
                 | kw_public typeDeclaration error openParentheses functionVars
                   closeParentheses openBraces statement kw_return  expression Semicolon closeBraces methodDeclaration
                   {yyerror ("invalid identifier declaration "); }
                 | kw_public typeDeclaration identifier error functionVars
                   closeParentheses openBraces statement kw_return  expression Semicolon closeBraces methodDeclaration
                   {yyerror ("'(' expected "); }
                 | kw_public typeDeclaration identifier openParentheses functionVars
                   error openBraces statement kw_return  expression Semicolon closeBraces methodDeclaration
                   {yyerror ("')' expected "); }
                 | kw_public typeDeclaration identifier openParentheses functionVars
                   closeParentheses error statement kw_return  expression Semicolon closeBraces methodDeclaration
                   {yyerror ("'{' expected"); }
                 | kw_public typeDeclaration identifier openParentheses functionVars
                   closeParentheses openBraces statement error  expression Semicolon closeBraces methodDeclaration
                   {yyerror ("'return' expected"); }
                 | kw_public typeDeclaration identifier openParentheses functionVars
                   closeParentheses openBraces statement kw_return  expression error closeBraces methodDeclaration
                   {yyerror ("';' expected"); }
                 | kw_public typeDeclaration identifier openParentheses functionVars
                   closeParentheses openBraces statement kw_return  expression Semicolon error methodDeclaration
                   {yyerror ("')' expected"); }

                 |






                   
functionVars: functionVariables |
functionVariables :  typeDeclaration identifier | typeDeclaration identifier comma functionVariables 

statement:  
            varsDeclaration | 
            openBraces statement closeBraces|
            error statement closeBraces {yyerror ("'{' expected"); }|
            openBraces statement error {yyerror ("'}' expected"); } |
            kw_if openParentheses expression closeParentheses statement kw_else statement |
            error openParentheses expression closeParentheses statement kw_else statement {yyerror ("invalid expression"); }|
            kw_if error expression closeParentheses statement kw_else statement {yyerror ("'(' expected"); } |
            kw_if openParentheses expression error statement kw_else statement {yyerror ("')' expected"); } |
            kw_if openParentheses expression closeParentheses statement error statement {yyerror ("invalid expression"); } |
            kw_while openParentheses expression closeParentheses statement |
            error openParentheses expression closeParentheses statement {yyerror ("invalid expression"); } |
            kw_while error expression closeParentheses statement {yyerror ("'(' expected"); }  |
            kw_while openParentheses expression error statement {yyerror ("')' expected"); }|
            kw_print openParentheses expression closeParentheses Semicolon |
            error openParentheses expression closeParentheses Semicolon {yyerror ("invalid expression"); }|
            kw_print error expression closeParentheses Semicolon {yyerror ("'(' expected"); } |
            kw_print openParentheses expression error Semicolon {yyerror ("')' expected"); }|
            kw_print openParentheses expression closeParentheses error {yyerror ("';' expected"); }|
            identifier affectation expression Semicolon |
            error affectation expression Semicolon {yyerror ("invalid expression"); }|
            identifier error expression Semicolon {yyerror ("'=' expected"); } |
            identifier affectation expression error {yyerror ("';' expected"); } |
            identifier openSquareBrackets expression closeSquareBrackets affectation expression Semicolon|
            error openSquareBrackets expression closeSquareBrackets affectation expression Semicolon {yyerror ("invalid expression"); } |
            identifier error expression closeSquareBrackets affectation expression Semicolon {yyerror ("'[' expected"); } |
            identifier openSquareBrackets expression error affectation expression Semicolon {yyerror ("']' expected"); } |
            identifier openSquareBrackets expression closeSquareBrackets error expression Semicolon {yyerror ("'=' expected"); } |
            identifier openSquareBrackets expression closeSquareBrackets affectation expression error {yyerror ("';' expected"); } |

expression : expression operator expression|
	     expression error expression {yyerror ("'operator' expected"); }|
             expression openSquareBrackets expression closeSquareBrackets |
             expression error expression closeSquareBrackets {yyerror ("'[' expected"); } |
             expression openSquareBrackets expression error {yyerror ("']' expected"); } |
             expression dot kw_length |
             expression dot identifier openParentheses expression anotherExpression  |
             integerLiteral Semicolon |
             integerLiteral error {yyerror ("';' expected"); } |
             booleanLiteral Semicolon |
             booleanLiteral error {yyerror ("';' expected"); } |
             identifier |
             kw_this |
             kw_new identifier openParentheses closeParentheses |
             kw_new identifier error closeParentheses {yyerror ("'(' expected"); } |
             kw_new identifier openParentheses error  {yyerror ("')' expected"); }|
             notOperator expression |
             openParentheses expression closeParentheses  |
             error expression closeParentheses {yyerror ("'(' expected"); } |
             openParentheses expression error {yyerror ("')' expected"); }  |

anotherExpression: comma expression anotherExpression |
		   error expression anotherExpression {yyerror ("';' expected"); } |

%%

int yyerror(char const *msg) {
	err = 1;
	if(msg == "syntax error")
	fprintf(stderr, "erreur ligne %d :", nbLigne );
	else
	fprintf(stderr, msg);
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
  
     