%{
#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include "sintactic.tab.h" 
int nlines=1;
%}

%option noyywrap

%%

[0-9]+         { yylval.num = atoi(yytext); return (TKN_NUMBER); }
[a-z]        { yylval.var = strdup(yytext); return (TKN_VARIABLE); }
"**"|"\^"      { return POWER; }
"+"            { return PLUS; }
"-"            { return MINUS; }
"="            { return EQUALS; }
[\n]           {nlines++;}
[ \t]         
.             

%%

