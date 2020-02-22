%{
#include <stdio.h>
extern "C" int yylex();
extern "C" int yyparse();
void yyerror(const char *s){printf("error: %s",s);}
%}
%token NUMBER EOL
%left '+' '-'
%left '*' '/'

%%
cal :
    | cal exp EOL {printf("=%d\n",$2);}
;
exp : NUMBER {$$=$1;}
    | exp '+' exp {$$=$1+$3;}
    | exp '-' exp {$$=$1-$3;}
    | exp '*' exp {$$=$1*$3;}
    | exp '/' exp {$$=$1/$3;}
;
%%
int main(){
    yyparse();
}
