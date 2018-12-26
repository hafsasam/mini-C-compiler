# mini-C-compiler
A lexical and syntaxical analyser for basic C code. Outputs errors in terminal and in erreur.txt

#HOW TO USE
Compiling :

lex c.l
yacc -d c.y
gcc y.tab.c

or use make if you're on a linux machine

Execution :

[./]a.exe <file_to_compile>


