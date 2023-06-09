%{
#include <stdio.h>
#include <stdlib.h>
int nlines=0;
 void yyerror (char const *s){
    fprintf (stderr, "%s\n", s);
 }
%}

%option noyywrap

%%

[0-9]+         {printf("NUMBER: %d \n",atoi(yytext));}
[a-z]+         {printf("Variable: %s \n",yytext);}
"**"	       {printf("POWER: %s \n",yytext);}
"^"            {printf("POWER: %s \n",yytext);}
"+"            {printf("PLUS: %s \n",yytext);}
"-"            {printf("MINUS: %s \n",yytext);}
"="            {printf("EQUALS: %s \n",yytext);}
[\n]           {nlines++;}
[ \t]          { /* Ignore whitespace. */ }
.              { printf("Unrecognized character: %s\n", yytext); exit(1); }

%%
void main(int argc,char **argv)
{
if (argc>1)
 yyin=fopen(argv[1],"r");
else
 yyin=stdin;
yylex();
printf("\nNumero lineas analizadas: %d \n", (nlines+1));
}
