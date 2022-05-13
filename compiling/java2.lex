%{
	
 /* We usually need these... */	
 #include <stdio.h>	
 #include <stdlib.h>	
#include <string.h>
#include <math.h>
 #include "syntax.tab.h"	                                                                         	
 /* Local stuff we need here... */	
#include <math.h>	 			

extern char nom[];
extern char operSymbol [];
extern int intValue;

int nbLigne =1;

%}
delim            ([ \t]|(" ")) 
number           [0-9]
character        [a-zA-Z]
openParentheses    (\()
closeParentheses   (\))
openSquareBrackets                      (\[)
closeSquareBrackets                     (\])
openBraces                              (\{)
closeBraces                             (\})
COMMENT_LINE        "//"

identifier         ([A-Za-z_][A-Za-z0-9_]*) 
integerLiteral                          (("-")?{number}*)
booleanLiteral                          "true"|"false"
type                 {primitiveType}|array 
primitiveType              "boolean"|"int"|"float" 
array             ({primitiveType}{delim}+{openSquareBrackets}{delim*}{closeSquareBrackets})
oper           "=="|"<"|"+"|"-"|"*"|"!="     


%%

{delim}+        // do nothing 
"\n"            nbLigne++;
"class"                   return kw_class;
"public"                  return kw_public; 
"static"                  return kw_static; 
"void"                    return kw_void;
"main"                    return kw_main;
"extends"                 return kw_extends;
"return"                  return kw_return; 
"if"                      return kw_if;
"else"                    return kw_else;
"while"                   return kw_while;
"System.out.println"      return kw_print;
"this"                    return kw_this;
"new"                     return kw_new;
"length"                  return kw_length;
"String"                  return kw_String;


{type}  return _type;
{openParentheses}                       return openParentheses;
{closeParentheses}                      return closeParentheses;
{openSquareBrackets}                    return openSquareBrackets;
{closeSquareBrackets}                   return closeSquareBrackets;
{openBraces}                           { 
                                        enterScope();
                                        return openBraces;
                                       }
{closeBraces}                           {
                                             exitScope();
                                             return closeBraces;
                                        }

{oper}                                  {
                                        strcpy(operSymbol,yytext);
                                         return operator;
                                        }
"="                                     return affectation;
"!"                                  return notOperator;
"."                                     return dot;
";"                                     return Semicolon;
","                                     return comma;
"\""                                   return doubleQuote;
"\'"                                   return simpleQuote;



{booleanLiteral}                        return booleanLiteral;
{integerLiteral}                        {
                                            //strcpy(intValue,yytext);
                                            intValue = atoi(yytext);
                                            return integerLiteral;      
                                        }
{identifier}                            { 
                                             strcpy(nom, yytext);
                                          //   printf("nom=%s\n",nom);
                                             return identifier;
                                        }


\/\/.*                                     /* do nothing */   
"/*"                                {
                                             int isComment = 1;
                                             char c;
                                             while(isComment) {
                                                  c = input();
                                                  if(c == '*') {
                                                       char ch = input();
                                                       if(ch == '/') isComment = 0;
                                                       else unput(ch);
                                                  }
                                                  else if(c == '\n') nbLigne++;
                                                  else if(c == EOF) {
                                                  printf("Lexical error!, multiline comment not closed on line %d",nbLigne);                                                       
                                                  isComment = 0;
                                                  }
                                             }
                                        }


.                                     { printf("\n unexpected character on line %d \n",  nbLigne);   }
%%
