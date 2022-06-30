digit   [0-9]
word    [a-zA-Z]
%{
#include "cucu.tab.h"
#include <stdio.h>
#include <stdlib.h>
%}
%%

^"#define"[ ]+.+[ ]+.+               {yylval.string = strdup(yytext); fprintf (yyout,"Defined Macro\n"); return DEFINE;}
^"#include"[ ]*[<].+\.h[>]         {yylval.string = strdup(yytext); fprintf (yyout,"Included File\n"); return INCLUDE;}
(int)|(char[ ]*[*]{0,2})|(float)         { yylval.string = strdup(yytext); fprintf(yyout,"Type: %s\n", yytext); return TYPE;}
struct      {fprintf(yyout,"Keyword: struct\n"); return STRUCT;}
return      {fprintf(yyout,"Keyword: return\n"); return RETURN;}
if          {fprintf(yyout,"Keyword: if\n"); return IF;}
else        {fprintf(yyout,"Keyword: else\n"); return ELSE;}
do          {fprintf(yyout,"Keyword: do\n"); return DO;}
while       {fprintf(yyout,"Keyword: while\n"); return WHILE;}
for         {fprintf(yyout,"Keyword: for\n"); return FOR;}
[a-zA-Z][a-zA-Z0-9_\.]*     {yylval.string=strdup(yytext);fprintf(yyout,"Identifier: %s\n", yytext);  return IDENT;}
[-]?[0-9]+        {yylval.string = strdup(yytext); fprintf(yyout,"Number: %s ", yytext);  return NUMBER;}
[(]      {fprintf(yyout,"(\n"); return OPEN_BRAC;}
[)]      {fprintf(yyout,")\n"); return CLOSE_BRAC;}
[{]      {fprintf(yyout,"{\n");return OPEN_PARAN;}
[}]      {fprintf(yyout,"}\n");return CLOSE_PARAN;}
[[]      {fprintf(yyout,"[");return OPEN_SQ;}
[\]]     {fprintf(yyout,"]");return CLOSE_SQ;}
[;]      {fprintf(yyout,";");return SEMI;}
[,]      {fprintf(yyout,",\n"); return COMMA;}
[=][=]   {fprintf(yyout,"boolean operation ==\n"); return EQ;}
[!][=]   {fprintf(yyout,"boolean operation !=\n"); return NE;}
[&][&]?   {fprintf(yyout,"boolean operation and\n"); return AND;}
[|][|]?    {fprintf(yyout,"boolean operation or\n"); return OR;}
[<][=]    {fprintf(yyout,"boolean operation <=\n"); return LE;}
[>][=]    {fprintf(yyout,"boolean operation >=\n"); return GE;}
[<]       {fprintf(yyout,"boolean operation <\n"); return L;}
[>]       {fprintf(yyout,"boolean operation >\n"); return G;}
[=]       {fprintf(yyout,"Assignment = \n"); return ASSIGN;}
[+]       {fprintf(yyout,"ADD "); return ADD;}
[-]       {fprintf(yyout,"SUB "); return SUB;}
[/]       {fprintf(yyout,"DIVIDE "); return DIV;}
[*]       {fprintf(yyout,"MULTIPLY "); return MULTIPLY;}
\/\*.*\*\/   ;
["].*["]    {yylval.string = strdup(yytext); fprintf(yyout,"STRING : %s\n", yytext); return STRING;}
['].[']     {yylval.string = strdup(yytext); fprintf(yyout,"STRING : %s\n", yytext);  return CHARACTER; }
[\s]*     {;};

%%
    int yywrap(){
        return 1;
    }
    //(\[({digit})+\])*
    //yylval.number = atoi(yytext);
    // yylval.string = strdup(yytext);
