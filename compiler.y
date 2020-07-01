%{
  #include <stdio.h>
  #include <string.h>
  #include <stdlib.h>

  int tabsym[26];

  int yylex();
  void yyerror();
  extern int line_n;
%}

%union {int num; char *id;}
%token ENTRADA SAIDA FIM ENQUANTO FACA INC ZERA
%token <id> ID
%type <id> cmd cmds varlist

%%

program:
  ENTRADA varlist SAIDA varlist cmds FIM {
    //printf("tabsym[A] = %d\n", tabsym[0]);
    //printf("tabsym[B] = %d\n", tabsym[1]);
    //printf("tabsym[Z] = %d\n", tabsym[25]);
	printf("Codigo em C:\n%s%s\n", $2, $5);
	exit(0);
  }
;

varlist:
  ID {
    //tabsym[$1[0]-65] = 0;
    // variables start with value zero
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
    //tabsym[$1[0]-65] = tabsym[$3[0]-65];
	char* result = malloc(strlen($1) + strlen($3) + 5); strcpy(result, $1);
	strcat(result, " = "); strcat(result, $3); strcat(result, ";\n"); $$ = result;
    // copies second ID value to first
  }
  | INC '(' ID ')' {
    //(tabsym[$3[0]-65])++;
	char* result = malloc(strlen($3) + 4); strcpy(result, $3);
	strcat(result, "++;\n"); $$ = result;
    // adds 1 to ID value
  }
  | ZERA '(' ID ')' {
    //tabsym[$3[0]-65] = 0;
    // assigns 0 to ID
	char* result = malloc(strlen($3) + 6); strcpy(result, $3);
	strcat(result, " = 0;\n"); $$ = result;
  }
;

%%

void yyerror(){
  fprintf(stderr, "Syntax error at line %d\n", line_n);
};  

int main () {
  yyparse();
  return(0);
}
