%{
#include "md-type.hpp"
%}
%define parse.error verbose
%start BODY
%token CH ES_CH H1 H2 H3 H4 H5 H6 
%token NEWLINE 
%token UL LI IND 
%token INL_Q
%%
BODY: PARA_LIST
    | BODY SECTION1 
    ;
SECTION1: HEADER1
    | SECTION1 PARA_LIST
    | SECTION1 SECTION2
    ;
HEADER1: H1 TEXT NEWLINE 
    ;
SECTION2: HEADER2
    | SECTION2 PARA_LIST
    ;
HEADER2: H2 TEXT NEWLINE 
    ;
PARA_LIST: PARA
    | PARA_LIST PARA
    ;
PARA: 
    | TEXT
    | TEXT NEWLINE
    ;
TEXT: CH
    | ES_CH
    | TEXT CH
    | TEXT ES_CH
    | TEXT INL_Q
    ;
%%
int main(){
    yyparse();
}
