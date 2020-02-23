%{
#include "md-type.hpp"
// #include "md-parser.hpp"
#include "stdio.h"
extern "C" int yylex();
%}
%option noyywrap
DOT_ALL         (.|\n)
CH              ([^!\[\]`\*~\#\\|\n])
CH_NS           ([^!\[\]`\*~\#\\|\n|\ ])
TO_ESCAPE       ([!`\\~\#\*\~\[\]\|])

TEXT            ((#{7,})?{CH_NS}({CH})*)
HEADLINE        (#{1,6}\ .*)
ESCAPE          (\\{TO_ESCAPE})
INLINE_Q        (`.*`)
INDENT          ((\ )+)

%x IND
%x UL
%x LI

%%
^{HEADLINE}/\n      {printf("<headline>:'%s'\n",yytext);}
{TEXT}              {printf("<text>:'%s'\n",yytext);}
{ESCAPE}            {printf("<escaped>:'%s'\n",yytext);}
\n\n                {printf("<new para>\n");}
\n                  {printf("<new line>\n");}
{INLINE_Q}          {printf("<inline quote>'%s'\n", yytext);}


^{INDENT}             {printf("<indent start>:'%s'",yytext);BEGIN(IND);}
<IND>^{INDENT}        {printf("<indent cont>:'%s'",yytext);}
<IND>^{TEXT}          {printf("<text>:'%s'\n",yytext);BEGIN(INITIAL);}
<IND>^{ESCAPE}        {printf("<escaped>:'%s'\n",yytext);BEGIN(INITIAL);}
<IND>^{INLINE_Q}      {printf("<inline quote>'%s'\n", yytext);BEGIN(INITIAL);}
<IND>^\n\n            {printf("<new para>\n");BEGIN(INITIAL);}
<IND>^\n              {printf("<new line>\n");BEGIN(INITIAL);}
%%
