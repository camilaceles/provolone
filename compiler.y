%{
  #include <stdio.h>
  #include <string.h>

  int tabsym[26];

  int yylex();
  void yyerror();
  extern int line_n;
%}

%union {int num; char *id;}
%token ENTRADA SAIDA FIM ENQUANTO FACA INC ZERA
%token <id> ID
%type <id> cmd cmds

%%

program:
  ENTRADA varlist SAIDA varlist cmds FIM {
    printf("tabsym[A] = %d\n", tabsym[0]);
    printf("tabsym[B] = %d\n", tabsym[1]);
    printf("tabsym[Z] = %d\n", tabsym[25]);
  }
;

varlist:
  ID {
    tabsym[$1[0]-65] = 0;
    // variables start with value zero
  }
  | varlist ID
;

cmds:
  cmd cmds
  | cmd
;

cmd:
  ENQUANTO ID FACA cmds FIM {
    // TODO
  }
  | ID '=' ID {
    tabsym[$1[0]-65] = tabsym[$3[0]-65];
    // copies second ID value to first
  }
  | INC '(' ID ')' {
    (tabsym[$3[0]-65])++;
    // adds 1 to ID value
  }
  | ZERA '(' ID ')' {
    tabsym[$3[0]-65] = 0;
    // assigns 0 to ID
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
