bison -d compiler.y
flex compiler.l
gcc -o compilerlex.yy.c compiler.tab.c
