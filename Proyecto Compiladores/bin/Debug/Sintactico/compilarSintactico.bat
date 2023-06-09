bison -d sintactic.y
flex lexicoEnlazadoBison.l
gcc -o compiladoBison.exe lex.yy.c sintactic.tab.c