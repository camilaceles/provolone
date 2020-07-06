%{
  #include <stdio.h>
  #include <string.h>
  #include "compiler.tab.h"

  int line_n = 1;
%}

var         ([_a-zA-Z]+)
number      ([0-9]+)

%%

ENTRADA     { return (ENTRADA); }
SAIDA       { return (SAIDA); }
FIM         { return (FIM); }
ENQUANTO    { return (ENQUANTO); }
FACA        { return (FACA); }
INC         { return (INC); }
DEC         { return (DEC); }
ZERA        { return (ZERA); }
[=()]       { return yytext[0]; }
{var}       { yylval.id=strdup(yytext); return (ID); }
{number}    { yylval.id=strdup(yytext); return (NUM); }
[\n]        { line_n++; }
.           ;

%%
