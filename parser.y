%{
#include <stdio.h>
#include "parser.tab.h"
int yylex();
void yyerror(char *msg);
void yy_scan_string(const char* str);
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

lines : lines expr ';' { FILE* ret; ret = fopen("output.txt","a"); if(ret == NULL){ printf("파일 열기 실패\n"); return 1; } fprintf(ret, "%g\n", $2); fclose(ret); }
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
  FILE* ret;
  ret = fopen("output.txt", "a");
  if(ret == NULL){
    printf("파일 열기 실패\n");
    return;
  }
  fprintf(ret, "error\n");
  fclose(ret);
  printf("%s\n", msg);
}

int main(int argc, char* argv[])
{
  FILE* fp;
  char buf[2048];
  fp = fopen(argv[1], "r");
  if(fp == NULL){
     printf("파일 열기 실패\n");
     return 1;
  }

  while(fgets(buf, sizeof(buf), fp) != NULL){
  	yy_scan_string(buf);
	yyparse();
  }

  fclose(fp);
  return 0;
}
