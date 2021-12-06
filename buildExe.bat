flex lex.l
bison -d yacc.y
gcc -o application.exe lex.yy.c
start application.exe