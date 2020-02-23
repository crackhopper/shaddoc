%{
#include "md-type.hpp"
%}
%start BODY
%union {
    struct Headline* h;
    struct Block* b;
    struct Text* t;
}
%token <h> HEADLINE 
%token <t> TEXT
%token <b> BLOCK

%%
CONTENT:
    | BLOCK
    | TEXT
    | CONTENT BLOCK
    | CONTENT TEXT
    ;
SECTION: HEADLINE CONTENT
    ;
BODY: CONTENT
    | BODY SECTION
    ;
%%
int main(){
    yyparse();
}
