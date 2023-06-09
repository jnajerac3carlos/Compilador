%{
#include <stdio.h> //librerias 
#include <stdlib.h>
#include <math.h>
extern int yylex(void); // Declara la función yylex que será definida por el analizador léxico
extern int nlines; // Declara un contador externo para las líneas procesadas
extern char *yytext;// Declara una cadena externa que contiene el texto actual que se está analizando
extern FILE *yyin; // Declara un puntero a un archivo externo que será el archivo de entrada para el analizador
void yyerror(char *s);
double a = 0, b = 0, c = 0;

void calculateRoots();
%}

%union {
  double num;
  char* var;
}
%start input
%token <num> TKN_NUMBER
%token <var> TKN_VARIABLE
%token POWER
%token PLUS
%token MINUS
%token EQUALS
%%

input:
	input line|line
  ;

line: {a = b = c = 0;} equation {calculateRoots();}
  ;

equation:
  term EQUALS TKN_NUMBER 
  ;

term:
//cuadraticas
TKN_NUMBER TKN_VARIABLE POWER TKN_NUMBER PLUS TKN_NUMBER TKN_VARIABLE PLUS TKN_NUMBER {a=$1;b=$6;c=$9;}|
TKN_NUMBER TKN_VARIABLE POWER TKN_NUMBER MINUS TKN_NUMBER TKN_VARIABLE PLUS TKN_NUMBER {a=$1;b=$6*-1;c=$9;}|
TKN_NUMBER TKN_VARIABLE POWER TKN_NUMBER PLUS TKN_NUMBER TKN_VARIABLE MINUS TKN_NUMBER {a=$1;b=$6;c=$9*-1;}|
TKN_NUMBER TKN_VARIABLE POWER TKN_NUMBER MINUS TKN_NUMBER TKN_VARIABLE MINUS TKN_NUMBER {a=$1;b=$6*-1;c=$9*-1;}|

TKN_VARIABLE POWER TKN_NUMBER PLUS TKN_NUMBER TKN_VARIABLE PLUS TKN_NUMBER {a=1;b=$5;c=$8;}|
TKN_VARIABLE POWER TKN_NUMBER MINUS TKN_NUMBER TKN_VARIABLE PLUS TKN_NUMBER {a=1;b=$5*-1;c=$8;}|
TKN_VARIABLE POWER TKN_NUMBER PLUS TKN_NUMBER TKN_VARIABLE MINUS TKN_NUMBER {a=1;b=$5;c=$8*-1;}|
TKN_VARIABLE POWER TKN_NUMBER MINUS TKN_NUMBER TKN_VARIABLE MINUS TKN_NUMBER {a=1;b=$5*-1;c=$8*-1;}|

//lineales
TKN_VARIABLE POWER TKN_NUMBER PLUS TKN_NUMBER TKN_VARIABLE {a=1;b=$5;c=0;}|
TKN_VARIABLE POWER TKN_NUMBER MINUS TKN_NUMBER TKN_VARIABLE {a=1;b=$5*-1;c=0;}|


TKN_NUMBER TKN_VARIABLE  PLUS TKN_NUMBER  {a=$1;b=0;c=$4;}|
TKN_NUMBER TKN_VARIABLE  MINUS TKN_NUMBER  {a=$1;b=0;c=$4*1;}|
 ;

%%
//calculo de la raiz 
void calculateRoots() {
  if (a != 0 && b==0 && c!=0) {
      printf("La Raiz de la Ecuacion Lineal es: %5.2f\n", -c/a);
  } else {
    double discriminant = b*b - 4*a*c;
    if (discriminant < 0) {
      printf("La ecuacion tiene raices imaginarias.\n");
    } else {
      double root1 = (-b + sqrt(discriminant)) / (2*a);
      double root2 = (-b - sqrt(discriminant)) / (2*a);
      printf("Las Raices de la ecuacion son: %5.2f, %5.2f\n", root1, root2);
    }
  }
}
void yyerror(char *s) {
  printf("Error: %s->%s en la linea No.%d\n", s, yytext, nlines);
}
int main(int argc, char **argv) {
  if (argc > 1) {
    yyin = fopen(argv[1], "r");
    if (!yyin) {
      printf("Error: No se pudo abrir el archivo %s\n", argv[1]);
      return 1;
    }
  } else {
    yyin = stdin;
  }
  yyparse();
  return 0;
}
