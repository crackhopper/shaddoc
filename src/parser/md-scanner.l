%{
#include "md-type.hpp"
#include "md-parser.hpp"
#include "stdio.h"
extern "C" int yylex();
%}
%option noyywrap
%x TABLE
%x CODE_BLOCK
TO_ESCAPE       ([!`\\~\#\*\~\[\]\|])
ESCAPE          (\\{TO_ESCAPE})
INDENT          ((\ |\t)+|(\>)+)
MAY_INDENT      ((\ |\t)*|(\>)*)

%%
^######\       {printf("<h6>\n");yylval=6;return(H_MARK);}
^#####\        {printf("<h5>\n");yylval=5;return(H_MARK);}
^####\         {printf("<h4>\n");yylval=4;return(H_MARK);}
^###\          {printf("<h3>\n");yylval=3;return(H_MARK);}
^##\           {printf("<h2>\n");yylval=2;return(H_MARK);}
^#\            {printf("<h1>\n");yylval=1;return(H_MARK);}
^{INDENT}      {printf("<ind>\n");return(IND);}
^{MAY_INDENT}((\-|\+|\*)\ )    {printf("<ul>\n");return(UL);}
^{MAY_INDENT}([1-9][0-9]*\.\ ) {printf("<li>\n");return(LI);}
^(\-{3,})\n         {printf("<line-1>");return(LINE);}
^(\={3,})\n         {printf("<line-2>");return(LINE);}
^((\-\ ){2,}(\-))\n   {printf("<line-dot>");return(LINE);}

^(\|)           {printf("TABLE:\n");unput(yytext[0]);BEGIN TABLE;}
<TABLE>^[^\|]    {printf("ENDTABLE\n");unput(yytext[0]);BEGIN INITIAL;}
<TABLE>(\|)     {printf("<tsep>\n");return(TSEP);}
<TABLE>.        {printf("<tch>\n");return(TCH);}
<TABLE>{ESCAPE} {printf("<tches>\n");return(TCH_ES);}
<TABLE>\n       {printf("<tnew>\n");return(TNEWLINE);}
<TABLE>(\-{3,}) {printf("<tline>");return(TLINE);}
<TABLE>(\={3,}) {printf("<tline>");return(TLINE);}
<TABLE>((\-\ ){2,}(\-))   {printf("<tline>");return(TLINE);}


(\ |\t)+       {printf("<ch>s\n");yylval=' ';return(CH);}
(\ |\t){2,}$/\n {printf("<newline>tr2\n");return(NEWLINE);}
\n{2,}         {printf("<newline>n2\n");return(NEWLINE);}
\n             {printf("<newline>nl\n");return(NEWLINE);}
\`             {printf("<inl_q>\n");return(INL_Q);}
{ESCAPE}       {printf("<es_ch>\n");return(ES_CH);}
.              {printf("<ch>\n");return(CH);}
(\!\[.*\]\(.*\)) {printf("<image>\n");return(IMG);}
(\[.*\]\(.*\))   {printf("<link>\n");return(LINK);}

^{MAY_INDENT}(```.*\n)  {printf("<block_beg>\n");BEGIN CODE_BLOCK;}
<CODE_BLOCK>(.|\n)*/``` {printf("<block_content>\n");return(BLOCK);}
<CODE_BLOCK>^{MAY_INDENT}(```.*\n) {printf("<block_end>\n"); BEGIN INITIAL;}

<<EOF>>        {static int once = 0; if(once++==0) return(ENDFILE);else yyterminate();}


%%
