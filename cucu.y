%{
#include <stdio.h>
#include <stdlib.h>
#include <string.h>
//#include "lex.yy.c"
void yyerror (const char *s);
int yylex();
FILE *parse_out;
// FILE *yyin;
// FILE *yyout;
//int yywrap();
%}

%union {
    int number;
    char *string;
}

%token DO EQ NE ASSIGN ADD SUB DIV MULTIPLY PRINT SCAN RETURN IF ELSE WHILE FOR SEMI OPEN_PARAN CLOSE_PARAN COMMA OPEN_BRAC CLOSE_BRAC AND OR LE GE G L OPEN_SQ CLOSE_SQ STRUCT
%token <string> DEFINE
%token <string> INCLUDE
%token <string> IDENT
%token <string> CHARACTER
%token <string> STRING
%token <string> NUMBER
%token <string> TYPE


%%
    start: header program
    ;
    
    header : header header
    | DEFINE {fprintf(parse_out,"Defined macro by : %s\n", $1);}
    | INCLUDE {fprintf(parse_out,"Included files by : %s\n", $1);}
    |
    ;
    
    program: var_in SEMI
//    | var_dec SEMI
//    | var_dec SEMI program
    | struct
    | struct program
    | var_in SEMI program
    | func_dec
    | func_def
//    | var_dec program
//    | var_in program
//    | func_dec program
//    | func_def program
    ;
    
    struct : STRUCT IDENT OPEN_PARAN {fprintf(parse_out,"Data Structure name: %s\n",$2);} stats CLOSE_PARAN SEMI
    ;
    
    var_in: TYPE IDENT ASSIGN expr COMMA var_in {fprintf(parse_out,"Type : %s\tIdentifier : %s\tAssignment : = \t", $1, $2);}
    | TYPE IDENT COMMA var_in
    | IDENT ASSIGN expr COMMA var_in {fprintf(parse_out,"Identifier : %s\tAssignment : = \t", $1);}
    | TYPE IDENT ASSIGN expr {fprintf(parse_out," TYPE: %s\tIdentifier : %s\tAssignment : = \t", $1,$2);}
    | TYPE IDENT {fprintf(parse_out," TYPE: %s\tIdentifier : %s\t", $1,$2);}
    | IDENT ASSIGN expr {fprintf(parse_out,"Identifier : %s\tAssign : \t", $1);}
    | IDENT COMMA var_in {fprintf(parse_out,"Identifier : %s\t", $1);}
    | IDENT IDENT {fprintf(parse_out,"Object : %s\tIdentifier : %s\n",$1, $2);}
    | IDENT {fprintf(parse_out,"Identifier : %s\n", $1);}
    | IDENT OPEN_SQ expr CLOSE_SQ var_in {fprintf(parse_out,"Identifier : %s\n", $1);}
    | IDENT OPEN_SQ expr CLOSE_SQ {fprintf(parse_out,"Identifier : %s\n", $1);}
    | TYPE IDENT OPEN_SQ expr CLOSE_SQ {fprintf(parse_out,"Type: %s\tIdentifier : %s\n", $1,$2);}
    | TYPE IDENT OPEN_SQ expr CLOSE_SQ var_in{fprintf(parse_out,"Type: %s\tIdentifier : %s\n", $1,$2);}
    ;
    
    
//    var_dec: TYPE IDENT COMMA var {fprintf(parse_out,"Type : %s\tIdentifier : %s\n", $1, $2);}
//    | TYPE IDENT {fprintf(parse_out,"Type : %s\t Identifier : %s\n", $1, $2);}
//    ;
    
    func_dec: TYPE IDENT OPEN_BRAC arg CLOSE_BRAC SEMI program {fprintf(parse_out,"Type : %s\nFunction name : %s\n", $1, $2);}
    | TYPE IDENT OPEN_BRAC arg CLOSE_BRAC SEMI {fprintf(parse_out,"Type : %s\nFunction name : %s\n", $1, $2);}
    | IDENT OPEN_BRAC arg CLOSE_BRAC SEMI program {fprintf(parse_out,"Function name : %s\n", $1);}
    | IDENT OPEN_BRAC arg CLOSE_BRAC SEMI {fprintf(parse_out,"\nFunction name : %s\n", $1);}
    ;
    
    func_def: TYPE IDENT OPEN_BRAC arg CLOSE_BRAC body program {fprintf(parse_out,"Function Return Type : %s\t Function Name : %s\n", $1, $2);}
    | TYPE IDENT OPEN_BRAC arg CLOSE_BRAC body {fprintf(parse_out,"Function Return Type : %s\t Function Name : %s\n", $1, $2);}
    | IDENT OPEN_BRAC arg CLOSE_BRAC body program {fprintf(parse_out,"\t Function Name : %s\n", $1);}
    | IDENT OPEN_BRAC arg CLOSE_BRAC body {fprintf(parse_out,"\t Function Name : %s\n", $1);}
    ;
    
    arg: TYPE IDENT COMMA arg {fprintf(parse_out,"Argument type : %s\t Argument Identifier : %s\n", $1, $2);}
    | TYPE IDENT {fprintf(parse_out,"Argument type : %s\t Argument Identifier : %s\n", $1, $2);}
    | {fprintf(parse_out,"Argument type : Void\n");}
    ;
    
    body: OPEN_PARAN stats CLOSE_PARAN
    |OPEN_PARAN CLOSE_PARAN
    ;
    
    stats: stats stat
    | stat
    |
    ;
    stat: var_in SEMI
//    |TYPE IDENT SEMI {fprintf(parse_out,"Type : %s, Identifier : %s\n",$1,$2);}
//    | TYPE IDENT ASSIGN expr SEMI {fprintf(parse_out,"Type : %s, Identifier : %s assigning to ", $1, $2);}
//    | IDENT ASSIGN expr SEMI { fprintf(parse_out,"Identifier : %s assigned to ", $1);}
    | RETURN expr SEMI {fprintf(parse_out,"Returning ");}
    | IF OPEN_BRAC expr CLOSE_BRAC lines {fprintf(parse_out,"If statement executed\n\t");} else
    | WHILE OPEN_BRAC expr CLOSE_BRAC {fprintf(parse_out,"While statement executed\n\t");} lines
    | DO lines WHILE OPEN_BRAC expr CLOSE_BRAC SEMI {fprintf(parse_out,"Do While statement executed\n\t");}
    | FOR OPEN_BRAC for_par SEMI for_par SEMI for_par CLOSE_BRAC lines
    | fun_call SEMI
    ;
    
    for_par: TYPE IDENT ASSIGN expr {fprintf(parse_out,"Type : %s\nIdentifier : %s\n Assigning : =\n", $1, $2);}
    | IDENT ASSIGN expr {fprintf(parse_out,"Identifier : %s\n Assigning : =\n", $1);}
    | expr
    |
    ;
    
    else: ELSE {fprintf(parse_out,"Else statement executed\n\t");} lines
    |
    ;
    lines: stat
    | OPEN_PARAN stats CLOSE_PARAN
    ;
    expr : or_exp AND expr {fprintf(parse_out,"AND ");}
    | or_exp
    or_exp: or_exp OR compare {fprintf(parse_out, "OR ");}
    | compare
    compare: compare EQ vle {fprintf(parse_out, "== ");}
    | vle NE compare {fprintf(parse_out, "!= ");}
    | vle GE compare {fprintf(parse_out, ">= ");}
    | vle LE compare {fprintf(parse_out, "<= ");}
    | vle L compare {fprintf(parse_out, "< ");}
    | vle G compare {fprintf(parse_out, "> ");}
    | vle
    vle: vle ADD fact {fprintf(parse_out, "+ ");}
    | vle SUB fact {fprintf(parse_out, "- ");}
    | fact
    fact: fact MULTIPLY tm {fprintf(parse_out, "* ");}
    | fact DIV tm {fprintf(parse_out, "/ ");}
    |tm
    tm: OPEN_BRAC expr CLOSE_BRAC
    | var
    var: IDENT {fprintf(parse_out,"Variable is : %s\n", $1);}
    | AND IDENT {fprintf(parse_out,"Identifier : %s\n", $2);}
    | NUMBER {fprintf(parse_out,"Variable is : %s\n", $1);}
    | IDENT OPEN_SQ expr CLOSE_SQ {fprintf(parse_out,"Identifier : %s\n ", $1);}
    | fun_call
    | str
    | chr
    str: STRING        {fprintf(parse_out,"String: %s\n", $1);}
    chr: CHARACTER      {fprintf(parse_out,"String: %s\n", $1);}
    ;
    fun_call: IDENT OPEN_BRAC CLOSE_BRAC  {fprintf (parse_out, "Function : %s\n", $1);}
    | IDENT OPEN_BRAC fun_para CLOSE_BRAC  {fprintf (parse_out, "Function: %s\n", $1);}
    ;
    
    fun_para: expr COMMA fun_para
    | expr
    ;   
    
%%
    extern FILE *yyin, *yyout;
    void yyerror (const char *s) {
        fprintf (parse_out,"%s\n", s);
    }
    int main(int argc, char **argv) {
        yyin = fopen(argv[1],"r");
        yyout = fopen("Lexer.txt", "w");
        parse_out = fopen("Parser.txt", "w");
      yyparse();
      printf("Done\n");
    }
