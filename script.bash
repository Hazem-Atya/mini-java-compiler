flex compiling/java2.lex
bison -d compiling/syntax.y
gcc syntax.tab.c lex.yy.c
./a.exe < testfile.java 