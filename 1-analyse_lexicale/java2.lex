%{
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


%%

{delim}+        // do nothing 
"\n"            nbLigne++;
"class"                   return class;
"public"                  return public; 
"static"                  return static; 
"void"                    return void;
"main"                    return main;
"extends"                 return extends;
"return"                  return return; 
"if"                      return if;
"else"                    return else;
"while"                   return while;
"System.out.println"      return print;
"this"                    return this;
"new"                     return new;
"length"                  return length;

{type}                              return type;
"String"                    return String
{openParentheses}                       return openParentheses;
{closeParentheses}                      return closeParentheses;
{openSquareBrackets}                    return openSquareBrackets;
{closeSquareBrackets}                   return closeSquareBrackets;
{openBraces}                            return openBraces;
{closeBraces}                           return closeBraces;

"&&"|"<"|"+"|"-"|"*"|"/"            return operator;
"="                                     return affectation;
"!"                                  return notOperator;
"."                                     return dot;
";"                                     return Semicolon;
","                                     return comma;
"\""                                   return doubleQuote;
"\'"                                   return simpleQuote;



{booleanLiteral}                        return booleanLiteral;
{integerLiteral}                        return integerLiteral;
{identifier}                            return indentifier;


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
int main(int argc, char *argv[]) 
{
     yyin = fopen(argv[1], "r");
     yylex();
     fclose(yyin);
}

int yywrap()
{
	return(1);
}


