%{
#include <stdio.h>
#include "cal.tab.h"
int yylex();
void yyerror(char *msg);
%}

%union{
	double d;
}
%token <d> NUMBER
%type <d> expr
%left '+' '-'
%left '*' '/'
%right UMINUS

%%

lines : lines expr ';' { printf("%g\n", $2); }
      | lines '\n'
      | /* empty */
      ;

expr : expr '+' expr       { $$ = $1 + $3; }
     | expr '-' expr       { $$ = $1 - $3; }
     | expr '*' expr       { $$ = $1 * $3; }
     | expr '/' expr       { $$ = $1 / $3; }
     | '(' expr ')'        { $$ = $2; }
     | '-' expr %prec UMINUS { $$ = - $2; }
     | NUMBER
     ;

%%

void yyerror(char *msg)
{
  printf("%s\n", msg);
}

int main(void)
{
  yyparse();
  return 0;
}
