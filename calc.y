%{
#include <stdio.h>
#include <stdlib.h>
#include <math.h>

#define NO_SYMS 30
#define YYDEBUG 1

struct symbol {
    char *name;
    int value;
};

static int last_sym = 0;
static struct symbol syms[NO_SYMS];
static int mksym(char *, int);
static int getsym(char *);
%}
%union {
    char *varname;
    int number;
}

%token <number> NUM
%token <varname> VAR
%type <number> expr
%left '='
%left '-' '+'
%left '*' '/'
%left NEG
%right '^'
%%

statement: expr { printf(" = %d\n", $1); }
    VAR '=' expr { mksym($3, $1); }
    ;

expr: NUM        { $$ = $1; }
    | VAR        { $$ = getsym($1); }
    | expr '+' expr { $$ = $1 + $3; }
    | expr '-' expr { $$ = $1 - $3; }
    | expr '*' expr { $$ = $1 * $3; }
    | expr '/' expr { $$ = $1 / $3; }
    | '-' expr %prec NEG { $$ = -$2; }
    | expr '^' expr { $$ = pow($1, $3); }
    |  '(' expr ')' { $$ = $2; }
    |  '|' expr '|' { $$ = $2; }
    ;
%%

int main(void) {
    while (1) {
        printf("> ");
        yyparse();
    }
}

static int mksym(char *sym, int value)
{
    if (last_sym == NO_SYMS) {
        fprintf(stderr, "Too many symbols \'%s\' cannot added.\n", sym);
        exit(1);
    }
    syms[last_sym].name = sym;
    syms[last_sym].value = value;
    last_sym++;
    return value;
}

static int getsym(char *sym)
{
    register int i;
    for (i = 0; i < last_sym; i++) {
        if (strcmp(syms[i].name, sym) == 0)
            return syms[i].value;
    }
    fprintf(stderr, "Cannot find symbol \'%s\'.\n", sym);
    return 0;
}
