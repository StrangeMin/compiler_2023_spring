%{
#include <stdio.h>
#include "parser.tab.h"
#define OTHER 253
%}

/* regexp definitions */
delim [ \t]
ws {delim}+
op [+\-()=*/]
int (0|[1-9]+[0-9]*)
number {int}(\.{int})?([eE][+\-]?{int}+)?
semicolon ;
newline \n
%%
{number} { yylval.d = atof(yytext); return NUMBER; }
{ws} { ; }
{semicolon} { return *yytext; }
{op} { return *yytext; }
{newline} {return *yytext; }
. { return OTHER; }
%%

int yywrap(){}


