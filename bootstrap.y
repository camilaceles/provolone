%{
  #include <stdio.h>
  #include <string.h>
  #include <stdlib.h>

  int yylex();
  void yyerror();
  extern int line_n;
  extern FILE *yyin;
%}

%union {int num; char *id;}
%token <id> ENTRADA SAIDA FIM ENQUANTO FACA INC ZERA SE ENTAO SENAO DEC VEZES
%token <id> ID NUM
%type <id> cmd cmds varlist saida

%%

program:
  ENTRADA varlist saida varlist cmds FIM {
    // writing result code onto output c file
    FILE *out = fopen("intermediario.in", "w");
    if (out == NULL) exit(1); // error opening file
    char* code = malloc(strlen($1) + strlen($2) +strlen($3) +strlen($4) + strlen($5) + strlen($6) + 5);
    strcpy(code, $1); strcat(code, " ");
    strcat(code, $2); strcat(code, " ");
    strcat(code, $3); strcat(code, " ");
    strcat(code, $4); strcat(code, "\n");
    strcat(code, $5);
    strcat(code, $6);
    fprintf(out, "%s", code);
    fclose(out);

    printf("Codigo intermediario gerado com sucesso - resultado em 'intermediario.in'\n");

    exit(0);
  }
;

varlist:
  varlist ID {
    char* result = malloc(strlen($1) + strlen($2));
    strcpy(result, $1);
    strcat(result, " ");
    strcat(result, $2);
    $$ = result;
  }
  | ID {$$ = $1;}
;

saida:
  SAIDA {
    char* result = malloc(strlen($1) + 25);
    strcpy(result, "__INT_VAR_A __INT_VAR_B ");
    strcat(result, $1);
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
    char* result = malloc(strlen($1) + strlen($2) + strlen($3) + strlen($4) + strlen($5) + 5);
	  strcpy(result, $1); strcat(result, " ");
    strcat(result, $2); strcat(result, " ");
    strcat(result, $3); strcat(result, "\n");
    strcat(result, $4);
    strcat(result, $5); strcat(result, "\n");
    $$ = result;
  }
  | SE ID ENTAO cmds FIM {
  	char* result = malloc(64 + strlen($4));
    strcpy(result, "__INT_VAR_A = ");
    strcat(result, $2);
    strcat(result, "\nENQUANTO __INT_VAR_A FACA\n");
    strcat(result, $4);
    strcat(result, "ZERA(__INT_VAR_A)\nFIM\n");
    $$ = result;
  }
  | SE ID ENTAO cmds SENAO cmds FIM {
  	char* result = malloc(228 + strlen($4) + strlen($6));
    strcpy(result, "__INT_VAR_A = ");
    strcat(result, $2);
    strcat(result, "\nENQUANTO __INT_VAR_A FACA\n");
    strcat(result, $4);
    strcat(result, "ZERA(__INT_VAR_A)\nFIM\nZERA(__INT_VAR_B)\nINC(__INT_VAR_B)\n__INT_VAR_A = ");
    strcat(result, $2);
    strcat(result, "\nENQUANTO __INT_VAR_A FACA\nZERA(__INT_VAR_B)\nZERA(__INT_VAR_A)\nFIM\nENQUANTO __INT_VAR_B FACA\n");
    strcat(result, $6);
    strcat(result, "ZERA(__INT_VAR_B)\nFIM\n");
    $$ = result;
  }
  | FACA ID VEZES cmds FIM{
    char* result = malloc(63 + strlen($4));
    strcpy(result, "__INT_VAR_A = ");
    strcat(result, $2);
    strcat(result, "\nENQUANTO __INT_VAR_A FACA\n");
    strcat(result, $4);
    strcat(result, "DEC(__INT_VAR_A)\n");
    strcat(result, "FIM\n");
	  $$ = result;
  }
  | ID '=' ID {
    char* result = malloc(strlen($1) + strlen($3) + 4); strcpy(result, $1);
    strcat(result, " = "); strcat(result, $3); strcat(result, "\n"); 
    $$ = result;
  }
  | ID '=' NUM {
    char* result = malloc(strlen($1) + strlen($3) + 4); strcpy(result, $1);
    strcat(result, " = "); strcat(result, $3); strcat(result, "\n"); 
    $$ = result;
  }
  | DEC '(' ID ')' {
    char* result = malloc(strlen($1) + strlen($3) + 3); strcpy(result, $1); strcat(result, "(");
    strcat(result, $3); strcat(result, ")\n"); 
    $$ = result;
  }
  | INC '(' ID ')' {
    char* result = malloc(strlen($1) + strlen($3) + 3); strcpy(result, $1); strcat(result, "(");
    strcat(result, $3); strcat(result, ")\n"); 
    $$ = result;
  }
  | ZERA '(' ID ')' {
    char* result = malloc(strlen($1) + strlen($3) + 3); strcpy(result, $1); strcat(result, "(");
    strcat(result, $3); strcat(result, ")\n"); 
    $$ = result;
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