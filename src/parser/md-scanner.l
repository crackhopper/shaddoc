%{
#include "md-parser.hpp"
#include "stdio.h"
extern "C" int yylex();
%}
%option noyywrap

%%
"+" |
"-" |
"*" |
"/" {return yytext[0];}
[0-9]+ {yylval=atoi(yytext);return NUMBER;}
"\n" {return EOL;}
%%
