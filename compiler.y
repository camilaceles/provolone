%{
  #include <stdio.h>
  #include <string.h>
  #include <stdlib.h>

  int yylex();
  void yyerror();
  extern int line_n;
  extern FILE *yyin;
%}

%union {char *id;}
%token ENTRADA SAIDA FIM ENQUANTO FACA INC DEC ZERA
%token <id> ID NUM
%type <id> cmd cmds varlist id

%%

program:
  ENTRADA varlist SAIDA varlist cmds FIM {
    // writing result code onto output c file
    FILE *out = fopen("out.c", "w");
    if (out == NULL) exit(1); // error opening file
    char* code = malloc(strlen($2) + strlen($4) + strlen($5) + 15);
    strcpy(code, "int main() {\n");
    strcat(code, $2); strcat(code, $4); strcat(code, $5);
    strcat(code, "}");
    fprintf(out, "%s", code);
    fclose(out);

    printf("Codigo C gerado com sucesso - resultado em 'out.c'\n");

    exit(0);
  }
;

varlist:
  varlist id {
    char* result = malloc(strlen($1) + strlen($2) + 1);
    strcpy(result, $1);
    strcat(result, $2);
    $$ = result;
  }
  | id {$$ = $1;}
;

id:
  ID {
    char* result = malloc(strlen($1) + 11);
    strcpy(result, "int ");
    strcat(result, $1); strcat(result, " = 0;\n");
    $$ = result;
  }
;

cmds:
  cmd cmds {
    char* result = malloc(strlen($1) + strlen($2) + 1);
    strcpy(result, $1); strcat(result, $2); $$ = result;
  }
  | cmd {$$ = $1;}
;

cmd:
  ENQUANTO ID FACA cmds FIM {
    char* result = malloc(strlen($2) + strlen($4) + 12); strcpy(result, "while(");
    strcat(result, $2); strcat(result, "){\n"); strcat(result, $4); strcat(result, "}\n");
    $$ = result;
  }
  | ID '=' ID {
    char* result = malloc(strlen($1) + strlen($3) + 6); strcpy(result, $1);
    strcat(result, " = "); strcat(result, $3); strcat(result, ";\n"); $$ = result;
  }
  | ID '=' NUM {
    char* result = malloc(strlen($1) + strlen($3) + 6); strcpy(result, $1);
    strcat(result, " = "); strcat(result, $3); strcat(result, ";\n"); $$ = result;
  }
  | INC '(' ID ')' {
    char* result = malloc(strlen($3) + 5); strcpy(result, $3);
    strcat(result, "++;\n"); $$ = result;
  }
  | DEC '(' ID ')' {
    char* result = malloc(strlen($3) + 5); strcpy(result, $3);
    strcat(result, "--;\n"); $$ = result;
  }
  | ZERA '(' ID ')' {
    char* result = malloc(strlen($3) + 7); strcpy(result, $3);
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
