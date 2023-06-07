%{
#include <stdio.h>
void yyerror(char *);
int yylex(void);
%}

%type <ldouble> expr
%token <ldouble> NUMBER
%left '+' '-'
%left '*' '/'
%right UMINUS
%union  {
                double ldouble;
                int lsym;
        }
%%

lines : lines stmt
      | lines '\n'
      | /* empty */
      ;

stmt : expr ';'            { printf("%g\n", $1); }
     ;

expr : NUMBER
     | expr '+' expr       { $$ = $1 + $3; }
     | expr '-' expr       { $$ = $1 - $3; }
     | expr '/' expr       { $$ = $1 / $3; }
     | expr '*' expr       { $$ = $1 * $3; }
     | '(' expr ')'        { $$ = $2; }
     | '-' expr %prec UMINUS { $$ = - $2; }
     ;

%%


void yyerror(char *s)
{
  printf("error\n");
}


int main(void)
{
  yyparse();
  return 0;
}
