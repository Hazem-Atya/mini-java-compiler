flex java2.lex
bison -d syntax.y
gcc syntax.tab.c lex.yy.c
#./a.exe < testfile.java 