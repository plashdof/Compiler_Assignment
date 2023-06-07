%{
#include "calc.tab.h"
#include <stdlib.h>
void yyerror(char *);
%}

/* regexp definitions */
delim [ \t]
ws {delim}+

digit [0-9]
number {integer}(\.{digit}+)?((E|e)[+\-]?{digit}+)?
integer (0|([1-9]{digit}*))

letter [A-Za-z]

operator [-+()=/*]
semicolon ;
newline \n

%%

{number} { yylval.ldouble = atof(yytext); return NUMBER; }
{operator} { return *yytext; }
{ws} ;
{semicolon} { return *yytext; }
{newline} { return *yytext; }

%%

int yywrap(void)
{
  return 1;
}
