%{
	

#include <stdio.h>	
 			
int yyerror(char const *msg);	
int yylex(void);
extern int yylineno;

%}


%token  class
%token  public 
%token  static 
%token  void
%token  main
%token  extends
%token  return 
%token  if
%token  else
%token  while
%token  print
%token  this
%token  new
%token  length
%token  type
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
%token  indentifier


%start program
%%
                                                           
program	     : mainClass classDeclaration  
mainClass : class identifier openBraces public static 
            void main openParentheses String openSquareBrackets closeSquareBrackets  
            identifier openBraces Statement closeBraces closeBraces

classDeclaration: class identifier parentClass openBraces varsDeclaration 
                  methodDeclaration closeBraces |classDeclaration |

parentClass: extends identifier | 

varsDeclaration: type identifier point_virgule | varsDeclaration | 

methodDeclaration: public type identifier openParentheses functionVars 
                   closeParentheses openBraces statement 
                   return  expression point_virgule closeBraces
                   
functionVars: functionVariables |
functionVariables :  type identifier | type identifier comma functionVariables

statement:  openBraces statement closeBraces |
            if openParentheses expression closeParentheses statement else statement |
            while openParentheses expression closeParentheses statement |
            print openParentheses expression closeParentheses point_virgule |
            identifier affectation expression point_virgule |
            identifier openSquareBrackets expression closeSquareBrackets affectation expression point_virgule

expression : expression operator expression|
             expression openSquareBrackets expression closeSquareBrackets |
             expression dot length |
             expression dot identifier openParentheses expression anotherExpression  |
             integerLiteral point_virgule |
             booleanLiteral point_virgule |
             indentifier |
             this |
             new identifier openParentheses closeParentheses |
             notOperator expression |
             openParentheses expression closeParentheses  

anotherExpression: comma expression anotherExpression | 

%% 

int yyerror(char const *msg) {
       
	
	fprintf(stderr, "%s %d\n", msg,yylineno);
	return 0;
	
	
}

extern FILE *yyin;

main()
{
 yyparse();
 
 
}