%{
  #include <stdio.h>
  #include <string.h>
  #include <stdlib.h>

  int tabsym[26];

  int yylex();
  void yyerror();
  extern int line_n;
  extern FILE *yyin;
%}

%union {int num; char *id;}
%token ENTRADA SAIDA FIM ENQUANTO FACA INC ZERA
%token <id> ID
%type <id> cmd cmds varlist

%%

program:
  ENTRADA varlist SAIDA varlist cmds FIM {
    printf("Codigo em C:\n%s%s\n", $2, $5);
    exit(0);
  }
;

varlist:
  ID {
    char* result = malloc(strlen($1) + 10);
    strcpy(result, "int ");
    strcat(result, $1); strcat(result, " = 0;\n");
    $$ = result;
  }
  | varlist ID {
    char* result = malloc(strlen($1) + strlen($2));
    strcpy(result, $1); strcat(result, "int ");
    strcat(result, $2); strcat(result, " = 0;\n");
    $$ = result;
  }
;

cmds:
  cmd cmds {
    char* result = malloc(strlen($1) + strlen($2));
    strcpy(result, $1); strcat(result, $2); $$ = result;
  }
  | cmd {$$ = $1;}
;

cmd:
  ENQUANTO ID FACA cmds FIM {
    char* result = malloc(11 + strlen($2) + strlen($4)); strcpy(result, "while(");
    strcat(result, $2); strcat(result, "){\n"); strcat(result, $4); strcat(result, "}\n");
    $$ = result;
  }
  | ID '=' ID {
    char* result = malloc(strlen($1) + strlen($3) + 5); strcpy(result, $1);
    strcat(result, " = "); strcat(result, $3); strcat(result, ";\n"); $$ = result;
  }
  | INC '(' ID ')' {
    char* result = malloc(strlen($3) + 4); strcpy(result, $3);
    strcat(result, "++;\n"); $$ = result;
  }
  | ZERA '(' ID ')' {
    char* result = malloc(strlen($3) + 6); strcpy(result, $3);
    strcat(result, " = 0;\n"); $$ = result;
  }
;

%%

void yyerror(){
  fprintf(stderr, "Syntax error at line %d\n", line_n);
};  

int main (int argc, char** argv) {
  if (argc > 1) {
    yyin = fopen(argv[1], "r");
  }
  yyparse();
  if (argc > 1) {
    fclose(yyin);
  }

  return(0);
}