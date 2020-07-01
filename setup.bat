bison -d compiler.y
flex compiler.l
gcc -o compiler lex.yy.c compiler.tab.c -ll
