%{
  #include <stdio.h>
  #include <string.h>
  #include "bootstrap.tab.h"

  int line_n = 1;
%}

var         ([A-Z])

%%

ENTRADA     { yylval.id=strdup(yytext); return (ENTRADA);}
SAIDA       { yylval.id=strdup(yytext); return (SAIDA);}
FIM         { yylval.id=strdup(yytext); return (FIM);}
ENQUANTO    { yylval.id=strdup(yytext); return (ENQUANTO);}
FACA        { yylval.id=strdup(yytext); return (FACA);}
SE			{ yylval.id=strdup(yytext); return (SE);}
ENTAO		{ yylval.id=strdup(yytext); return (ENTAO);}
SENAO		{ yylval.id=strdup(yytext); return (SENAO);}
INC         { yylval.id=strdup(yytext); return (INC);}
DEC         { yylval.id=strdup(yytext); return (DEC);}
ZERA        { yylval.id=strdup(yytext); return (ZERA);}
[=()]       { return yytext[0]; }
{var}       { yylval.id=strdup(yytext); return (ID); }
[\n]        { line_n++; }
.           ;

%%