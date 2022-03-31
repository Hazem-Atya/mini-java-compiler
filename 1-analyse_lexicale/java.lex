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
primitiveType              "boolean"|"int"|"float"|"String"
array             ({primitiveType}{delim}+{openSquareBrackets}{delim*}{closeSquareBrackets})


%%

{delim}+        // do nothing 
"\n"            nbLigne++;
"class"                   printf("keyword: %s \n",yytext);
"public"                  printf("keyword: %s \n",yytext);
"static"                  printf("keyword: %s \n",yytext);
"void"                    printf("keyword: %s \n",yytext);
"main"                    printf("keyword: %s \n",yytext);
"extends"                 printf("keyword: %s \n",yytext);
"return"                  printf("keyword: %s \n",yytext); 
"if"                      printf("keyword: %s \n",yytext);
"else"                    printf("keyword: %s \n",yytext);
"while"                   printf("keyword: %s \n",yytext);
"System.out.println"      printf("keyword: %s \n",yytext);
"this"                    printf("keyword: %s \n",yytext);
"new"                     printf("keyword: %s \n",yytext);
"length"                  printf("keyword: %s \n",yytext);

{type}                              printf("Type: %s \n",yytext);

{openParentheses}                       printf("open parentheses: %s \n",yytext);
{closeParentheses}                      printf("close parentheses: %s \n",yytext);
{openSquareBrackets}                    printf("Open square brackets: %s \n",yytext);
{closeSquareBrackets}                   printf("Close square brackets: %s \n",yytext);
{openBraces}                            printf("Open braces: %s \n",yytext);
{closeBraces}                           printf("Close braces: %s \n",yytext);

"&&"|"<"|"+"|"-"|"*"|"!"|"="|"/"            printf("Operator: %s \n",yytext);
"."                                     printf("Dot: %s \n",yytext);
";"                                     printf("Semicolon: %s \n",yytext);
","                                     printf("Comma: %s \n",yytext);
"\""                                    printf("Double quote: %s \n",yytext);
"\'"                                    printf("Simple quote: %s \n",yytext);



{booleanLiteral}                        printf("Boolean Literal: %s \n",yytext);
{integerLiteral}                        printf("Integer Literal: %s \n",yytext);
{identifier}                            printf("identifier: %s \n",yytext);


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


