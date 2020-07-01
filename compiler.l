%{
  #include <stdio.h>
  #include <string.h>
  #include "compiler.tab.h"

  int line_n = 1;
%}

var         ([A-Z])

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
[\n]        { line_n++; }
.           ;

%%
