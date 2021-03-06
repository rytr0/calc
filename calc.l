%{
#include <stdlib.h>
#include <string.h>
#include "y.tab.h"
%}

%%

[0-9]+(\.[0-9]+)? { yylval.number = atof(yytext); return NUM; }

[-+*/()=|^] return *yytext; 

q|quit|exit { printf("Bye!\n"); exit(0); }

[a-zA-Z]+ { yylval.varname = strdup(yytext); return VAR; }

[\t ]+ ; 
#.* ;

\n return 0; 

<<EOF>> { printf("Bye!\n"); exit(0); }

%%
