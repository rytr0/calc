%{
#include <stdio.h>
#include <stdlib.h>
#include <math.h>
%}
%token NUMBER
%left '-' '+'
%left '*' '/'
%left NEG
%right '^'
%%

statement: expr { printf(" = %d\n", $1); }
    ;

expr: NUMBER        { $$ = $1; }
    | expr '+' expr { $$ = $1 + $3; }
    | expr '-' expr { $$ = $1 - $3; }
    | expr '*' expr { $$ = $1 * $3; }
    | expr '/' expr { $$ = $1 / $3; }
    | '-' expr %prec NEG { $$ = -$2; }
    | expr '^' expr { $$ = pow($1, $3); }
    |  '(' expr ')' { $$ = $2; }
    ;
%%

int main(void) {
    while (1) {
        printf("> ");
        yyparse();
    }
}
