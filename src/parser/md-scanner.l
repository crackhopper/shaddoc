%{
#include "md-type.hpp"
#include "md-parser.hpp"
#include "stdio.h"
extern "C" int yylex();
%}
%option noyywrap
ANY (.|\n)
NEWLINE (\r\n|\n)
NONEWLINE [^\r\n]
NORMAL_CHARACTOR [^`#-]

%%
"## "{NONEWLINE}*{NEWLINE} {yylval.h=newHeadline(H2, yytext+3);return HEADLINE;}
"# "{NONEWLINE}*{NEWLINE} {yylval.h=newHeadline(H1, yytext+2);return HEADLINE;}
"```"{ANY}*"```" {yylval.b=newBlock(yytext+3);return BLOCK;}
[^`#-]{NORMAL_CHARACTOR}* {yylval.t=newText(yytext);return TEXT;}

%%
