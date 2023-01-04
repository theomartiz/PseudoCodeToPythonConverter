# Custom pseudo-code to Python converter (a school project to understand compilation processes)

Main objectives of the assignement:
- Define a pseudo-code grammar
- Run a lexical analysis on a sample of this PC (with LEX tool)
- Run a syntax analysis and construct a parse tree (with Yacc tool)
- Generate a python code from this parse tree

RUN
- `yacc -d yacc.y` to get y.tab.c and y.tab.h files (y.tab.h is required by lex.l for token definitions)
- `lex lex.l` to get lex.yy.c file
- `cc lex.yy.c y.tab.c` to compile and get a.out executable
- `./a.out to test`

OR RUN yacc -d yacc.y && lex lex.l && cc main.c && ./a.out input.txt

TO RUN ON WINDOWS:
- 'flex "fileName.l"'
- 'bison -d "fileName.y"'
- 'gcc -o "executableName.exe" "fileName.yy.c"

or run the batch file buildExe.bat

A faire: 
  - Debug newline et tab
