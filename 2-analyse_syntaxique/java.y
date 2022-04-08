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
            identifier closeParentheses openBraces statement closeBraces closeBraces {yyerror ("le mot cle 'class' est manquant");  YYABORT}
          | kw_class error openBraces kw_public kw_static kw_void kw_main openParentheses kw_String openSquareBrackets closeSquareBrackets
            identifier closeParentheses openBraces statement closeBraces closeBraces {yyerror (" le nom du classe est manquant"); YYABORT }
	  | kw_class identifier error kw_public kw_static kw_void kw_main openParentheses kw_String openSquareBrackets closeSquareBrackets
            identifier closeParentheses openBraces statement closeBraces closeBraces {yyerror ("'{' expected"); YYABORT }
          | kw_class identifier openBraces error kw_static kw_void kw_main openParentheses kw_String openSquareBrackets closeSquareBrackets
            identifier closeParentheses openBraces statement closeBraces closeBraces {yyerror ("le mot cle 'public' est manquant"); YYABORT }
          | kw_class identifier openBraces kw_public error kw_void kw_main openParentheses kw_String openSquareBrackets closeSquareBrackets
            identifier closeParentheses openBraces statement closeBraces closeBraces {yyerror ("le mot cle 'static' est manquant"); YYABORT }
          | kw_class identifier openBraces kw_public kw_static error kw_main openParentheses error openSquareBrackets closeSquareBrackets
            identifier closeParentheses openBraces statement closeBraces closeBraces {yyerror ("le type de la methode est manquant"); YYABORT}
 	  | kw_class identifier openBraces kw_public kw_static kw_void error openParentheses kw_String openSquareBrackets closeSquareBrackets
            identifier closeParentheses openBraces statement closeBraces closeBraces {yyerror ("la methode main est introuvable"); YYABORT}
         | kw_class identifier openBraces kw_public kw_static kw_void kw_main error kw_String openSquareBrackets closeSquareBrackets
            identifier closeParentheses openBraces statement closeBraces closeBraces {yyerror ("'(' expected"); YYABORT }
          | kw_class identifier openBraces kw_public kw_static kw_void kw_main openParentheses kw_String error closeSquareBrackets
            identifier closeParentheses openBraces statement closeBraces closeBraces {yyerror ("'[' expected"); YYABORT}
          | kw_class identifier openBraces kw_public kw_static kw_void kw_main openParentheses kw_String openSquareBrackets error
            identifier closeParentheses openBraces statement closeBraces closeBraces {yyerror ("']' expected"); YYABORT }
          | kw_class identifier openBraces kw_public kw_static kw_void kw_main openParentheses kw_String openSquareBrackets closeSquareBrackets
            error closeParentheses openBraces statement closeBraces closeBraces {yyerror ("invalid parameter syntax"); YYABORT}
          | kw_class identifier openBraces kw_public kw_static kw_void kw_main openParentheses error openSquareBrackets closeSquareBrackets
            identifier closeParentheses openBraces statement closeBraces closeBraces {yyerror ("invalid parameter syntax"); YYABORT }
          | kw_class identifier openBraces kw_public kw_static kw_void kw_main openParentheses kw_String openSquareBrackets closeSquareBrackets
            identifier error openBraces statement closeBraces closeBraces {yyerror ("')' expected"); YYABORT}
          | kw_class identifier openBraces kw_public kw_static kw_void kw_main openParentheses kw_String openSquareBrackets closeSquareBrackets
            identifier closeParentheses error statement closeBraces closeBraces {yyerror ("'{' expected"); YYABORT}
          | kw_class identifier openBraces kw_public kw_static kw_void kw_main openParentheses kw_String openSquareBrackets closeSquareBrackets
            identifier closeParentheses openBraces error closeBraces closeBraces {yyerror ("la fonction main est vide"); YYABORT }
	  | kw_class identifier openBraces kw_public kw_static kw_void kw_main openParentheses kw_String openSquareBrackets closeSquareBrackets
            identifier closeParentheses openBraces statement error closeBraces {yyerror ("'}' expected"); YYABORT}
          | kw_class identifier openBraces kw_public kw_static kw_void kw_main openParentheses kw_String openSquareBrackets closeSquareBrackets
            identifier closeParentheses openBraces statement closeBraces error {yyerror ("'}' expected"); YYABORT}


classDeclaration: kw_class identifier parentClass openBraces varsDeclaration 
                  methodDeclaration closeBraces classDeclaration
                | error identifier parentClass openBraces varsDeclaration
                  methodDeclaration closeBraces classDeclaration {yyerror ("'class' expected"); YYABORT }
                | kw_class error parentClass openBraces varsDeclaration
                  methodDeclaration closeBraces classDeclaration {yyerror ("class name expected"); YYABORT}
                | kw_class identifier parentClass error varsDeclaration
                  methodDeclaration closeBraces classDeclaration {yyerror ("'{' expected"); YYABORT }
                | kw_class identifier parentClass openBraces varsDeclaration
                  methodDeclaration error classDeclaration {yyerror ("'}' expected"); YYABORT}
                |

parentClass: kw_extends identifier
	   | error identifier {yyerror ("'extends' expected"); YYABORT }
	   | kw_extends error {yyerror ("invalid Parent class name "); YYABORT}
	   |

identifierOrNumber: identifier | integerLiteral

varsDeclaration: typeDeclaration identifier Semicolon varsDeclaration
	       | typeDeclaration identifier affectation identifierOrNumber Semicolon varsDeclaration
	       | error identifier Semicolon varsDeclaration {yyerror ("invalid expression "); YYABORT}
	       | typeDeclaration error Semicolon varsDeclaration {yyerror ("invalid identifier declaration "); YYABORT}
	       | typeDeclaration identifier error varsDeclaration {yyerror (" ';' expected "); YYABORT}
	       | error identifier affectation identifierOrNumber Semicolon varsDeclaration {yyerror ("invalid type declaration "); YYABORT}
	       | typeDeclaration error affectation identifierOrNumber Semicolon varsDeclaration {yyerror ("invalid identifier declaration "); YYABORT}
	       | typeDeclaration identifier error identifierOrNumber Semicolon varsDeclaration{yyerror ("'=' expected "); YYABORT}
	       | typeDeclaration identifier affectation error Semicolon varsDeclaration {yyerror ("invalid identifier affectation "); YYABORT}
	       | typeDeclaration identifier affectation identifierOrNumber error varsDeclaration {yyerror ("';' expected "); YYABORT}
	       | typeDeclaration identifier affectation kw_new identifier openParentheses closeParentheses Semicolon varsDeclaration
	       | typeDeclaration identifier affectation kw_new identifier openParentheses closeParentheses Semicolon varsDeclaration
	       | typeDeclaration identifier affectation kw_new identifier error closeParentheses Semicolon varsDeclaration {yyerror ("'(' expected "); YYABORT}
	       | typeDeclaration identifier affectation kw_new identifier openParentheses error Semicolon varsDeclaration{yyerror ("')' expected "); YYABORT}
	       | typeDeclaration identifier affectation kw_new identifier openParentheses closeParentheses error varsDeclaration{yyerror ("';' expected "); YYABORT}
	       | typeDeclaration identifier affectation kw_new error openParentheses closeParentheses Semicolon varsDeclaration{yyerror ("invalid expression "); YYABORT}

	       |
typeDeclaration : _type | kw_String
methodDeclaration: kw_public typeDeclaration identifier openParentheses functionVars 
                   closeParentheses openBraces statement kw_return  expression Semicolon closeBraces methodDeclaration
                 | kw_public typeDeclaration identifier openParentheses  closeParentheses openBraces closeBraces methodDeclaration
                 | error typeDeclaration identifier openParentheses functionVars
                   closeParentheses openBraces statement kw_return  expression Semicolon closeBraces methodDeclaration
                   {yyerror ("'public' expected "); YYABORT}
                 | kw_public error identifier openParentheses functionVars
                   closeParentheses openBraces statement kw_return  expression Semicolon closeBraces methodDeclaration
                   {yyerror ("invalid expression "); YYABORT}
                 | kw_public typeDeclaration error openParentheses functionVars
                   closeParentheses openBraces statement kw_return  expression Semicolon closeBraces methodDeclaration
                   {yyerror ("invalid expression  "); YYABORT}
                 | kw_public typeDeclaration identifier error functionVars
                   closeParentheses openBraces statement kw_return  expression Semicolon closeBraces methodDeclaration
                   {yyerror ("invalid expression "); YYABORT}
                 | kw_public typeDeclaration identifier openParentheses functionVars
                   error openBraces statement kw_return  expression Semicolon closeBraces methodDeclaration
                   {yyerror ("')' expected "); YYABORT}
                 | kw_public typeDeclaration identifier openParentheses functionVars
                   closeParentheses error statement kw_return  expression Semicolon closeBraces methodDeclaration
                   {yyerror ("'{' expected"); YYABORT}
                 | kw_public typeDeclaration identifier openParentheses functionVars
                   closeParentheses openBraces statement error  closeBraces methodDeclaration
                   {yyerror ("return statement is missing"); YYABORT}
                 | kw_public typeDeclaration identifier openParentheses functionVars
                   closeParentheses openBraces statement kw_return  expression error closeBraces methodDeclaration
                   {yyerror ("';' expected"); YYABORT}
                 | kw_public typeDeclaration identifier openParentheses functionVars
                   closeParentheses openBraces statement kw_return  expression Semicolon error methodDeclaration
                   {yyerror ("')' expected"); YYABORT }

                 |

                   
functionVars: functionVariables |
functionVariables :  typeDeclaration identifier | typeDeclaration identifier comma functionVariables
| typeDeclaration identifier error functionVariables {yyerror ("',' expected"); YYABORT}

statement:  
            varsDeclaration statement |
            openBraces statement closeBraces |
            kw_if openParentheses expression closeParentheses statement kw_else statement |
            error openParentheses expression closeParentheses statement kw_else statement {yyerror ("invalid expression");  YYABORT }|
            kw_if error expression closeParentheses statement kw_else statement {yyerror ("'(' expected from statement if"); YYABORT } |
            kw_if openParentheses expression error statement kw_else statement {yyerror ("')' expected"); } |
            kw_if openParentheses expression closeParentheses statement error statement {yyerror ("invalid expression"); YYABORT } |
            kw_while openParentheses expression closeParentheses statement |
            error openParentheses expression closeParentheses statement {yyerror ("invalid expression"); YYABORT} |
            kw_while error expression closeParentheses statement {yyerror ("'(' expected from statement while"); YYABORT }  |
            kw_while openParentheses expression error statement {yyerror ("')' expected"); }|
            kw_print openParentheses expression closeParentheses Semicolon statement |
            error openParentheses expression closeParentheses Semicolon {yyerror ("invalid expression"); YYABORT }|
            kw_print error expression closeParentheses Semicolon {yyerror ("'(' expected from statement print"); YYABORT } |
            kw_print openParentheses expression error Semicolon {yyerror ("')' expected"); YYABORT}|
            kw_print openParentheses expression closeParentheses error {yyerror ("';' expected"); YYABORT}|
            identifier affectation expression Semicolon  statement|
            error affectation expression Semicolon {yyerror ("invalid expression"); YYABORT}|
            identifier error expression Semicolon {yyerror ("invalid expression"); YYABORT } |
            identifier affectation expression error {yyerror ("';' expected"); YYABORT } |
            identifier openSquareBrackets expression closeSquareBrackets affectation expression Semicolon statement|
            error openSquareBrackets expression closeSquareBrackets affectation expression Semicolon {yyerror ("invalid expression"); YYABORT } |
            identifier error expression closeSquareBrackets affectation expression Semicolon {yyerror ("'[' expected"); YYABORT} |
            identifier openSquareBrackets expression error affectation expression Semicolon {yyerror ("']' expected"); YYABORT} |
            identifier openSquareBrackets expression closeSquareBrackets error expression Semicolon {yyerror ("'=' expected"); YYABORT } |
            identifier openSquareBrackets expression closeSquareBrackets affectation expression error {yyerror ("';' expected"); YYABORT} |
	      identifier dot identifier openParentheses methodCallParam closeParentheses
	      Semicolon statement|
	      identifier openParentheses methodCallParam closeParentheses
	      Semicolon statement|
	      error openParentheses methodCallParam closeParentheses Semicolon statement {yyerror ("invalid expression "); YYABORT}|
	      identifier  error  methodCallParam closeParentheses
	      Semicolon statement {yyerror ("invalid expression , '(' expected"); YYABORT}|
	      identifier  openParentheses  methodCallParam error
	      Semicolon statement {yyerror ("invalid expression , ')' expected"); YYABORT}|
	      identifier  openParentheses  methodCallParam closeParentheses
	      error statement {yyerror ("invalid expression , ';' expected"); YYABORT}|
	      error dot identifier openParentheses methodCallParam closeParentheses
	      Semicolon statement {yyerror ("invalid expression "); YYABORT}|
	      identifier dot error openParentheses methodCallParam closeParentheses
	      Semicolon statement {yyerror ("invalid expression "); YYABORT}|
	      identifier dot identifier error methodCallParam closeParentheses
	      Semicolon statement {yyerror ("'(' expected "); YYABORT}|
	      identifier dot identifier openParentheses methodCallParam error
	      Semicolon statement {yyerror ("')' expected "); YYABORT}|
	      identifier dot identifier openParentheses methodCallParam closeParentheses
	      error statement {yyerror ("';' expected "); YYABORT}|
	     kw_new identifier openParentheses closeParentheses Semicolon statement|
	     kw_new identifier openParentheses closeParentheses dot identifier openParentheses methodCallParam closeParentheses
	      Semicolon statement|
	      kw_new identifier openParentheses closeParentheses error identifier
	      openParentheses methodCallParam closeParentheses Semicolon statement {yyerror ("invalid expression "); YYABORT}|
	         kw_new identifier openParentheses closeParentheses dot error
	      openParentheses methodCallParam closeParentheses Semicolon statement {yyerror ("invalid expression "); YYABORT}|
	         kw_new identifier openParentheses closeParentheses dot identifier
	      error methodCallParam closeParentheses Semicolon statement {yyerror ("'(' expected"); YYABORT}|
	     kw_new identifier openParentheses closeParentheses dot identifier
	     openParentheses methodCallParam error Semicolon statement {yyerror ("')' expected"); YYABORT}|
	     kw_new identifier openParentheses closeParentheses dot identifier
	     openParentheses methodCallParam closeParentheses error statement {yyerror ("';' expected"); YYABORT}|
             kw_new identifier error closeParentheses Semicolon statement{yyerror ("'(' expected from new"); YYABORT} |
             kw_new identifier openParentheses error Semicolon statement{yyerror ("')' expected"); YYABORT }|
             kw_new identifier openParentheses closeParentheses error statement {yyerror ("';' expected"); YYABORT }|
methodCallParam : methodCallParams |
methodCallParams : identifierOrNumber comma methodCallParams | identifierOrNumber

expression : expression operator expression|
             expression openSquareBrackets expression closeSquareBrackets |
             expression error expression closeSquareBrackets {yyerror ("'[' expected"); YYABORT } |
             expression openSquareBrackets expression error {yyerror ("']' expected"); YYABORT } |
             expression dot kw_length |
             expression dot identifier openParentheses expression anotherExpression  |
             expression dot identifier dot identifier openParentheses expression anotherExpression  |
             integerLiteral Semicolon |
             integerLiteral error {yyerror ("';' expected"); YYABORT} |
             booleanLiteral Semicolon |
             booleanLiteral error {yyerror ("';' expected"); YYABORT} |
             identifier |
             kw_this |
             kw_new identifier openParentheses closeParentheses  |
             kw_new identifier openParentheses closeParentheses dot identifier openParentheses identifierOrNumber closeParentheses |
             kw_new identifier error closeParentheses {yyerror ("'(' expected from new"); YYABORT} |
             kw_new identifier openParentheses error  {yyerror ("')' expected"); YYABORT }|
             notOperator expression |
             openParentheses expression closeParentheses  |
             error expression closeParentheses {yyerror ("'(' expected from expression"); YYABORT} |
             openParentheses expression error {yyerror ("')' expected"); YYABORT}  |

anotherExpression: comma expression anotherExpression |
		   error expression anotherExpression {yyerror ("',' expected"); YYABORT} |

%%

int yyerror(char const *msg) {
	err = 1;
	if(msg == "syntax error")
	fprintf(stderr, "erreur ligne %d :", nbLigne );
	else
	{fprintf(stderr, "%s \n", msg);

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
     if(err==0)
     printf("Code compiled successfully");

	return(1);
}
  
     