%{
#include "md-type.hpp"
#include "md-parser.hpp"
#include "stdio.h"
extern "C" int yylex();
%}
%option noyywrap
TO_ESCAPE       ([!`\\~\#\*\~\[\]\|])
ESCAPE          (\\{TO_ESCAPE})


%%
^######\       {return(H6);}
^#####\        {return(H5);}
^####\         {return(H4);}
^###\          {return(H3);}
^##\           {printf("<h2>");return(H2);}
^#\            {printf("<h1>");return(H1);}
^(\t)+         {yylval=1;return(IND);}
^(\ )+         {yylval=2;return(IND);}
(\ |\t)+       {yylval=' ';return(CH);}
(\ |\t){2,}/\n {printf("<newline>");return(NEWLINE);}
\n{2,}         {printf("<newline>");return(NEWLINE);}
\n             {printf("<newline>");return(NEWLINE);}
((\-|\+|\*)\ ) {return(UL);}
([1-9][0-9]*\.\ )       {return(LI);}
\`             {return(INL_Q);}
{ESCAPE}       {printf("<es_ch>");return(ES_CH);}
.              {printf("<ch>");return(CH);}
<<EOF>>        {yyterminate();}

(\-{3,})       {printf("<line-1>");}
(\={3,})       {printf("<line-2>");}
((\-\ ){2,}(\-))   {printf("<line-dot>");}
(\|)           {printf("<sep>");}
^(```)         {printf("<block>");}
^(\>)          {printf("<q-indent>");}
(\!\[.*\]\(.*\)) {printf("<image>");}
(\[.*\]\(.*\)) {printf("<link>");}

%%
