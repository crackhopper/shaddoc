%{
#include "md-type.hpp"
%}
%define parse.error verbose
%start BODY
%token H_MARK
%token NEWLINE
%token UL LI 
%token INL_Q IND
%token CH ES_CH 
%token BLOCK
%token ENDFILE
%token LINE
%token TSEP TCH TCH_ES TLINE TNEWLINE
%token IMG LINK
%%
BODY: PARA_LIST {printf("(body->paralist)\n");}
    | BODY SECTION {printf("(body->body section)\n");}
    ;
SECTION: HEADER  {printf("(section->header)\n");}
    | HEADER PARA_LIST {printf("(section->header paralist)\n");}
    ;
HEADER: H_MARK TEXT NEWLINE  {printf("(header->hmark text newline)\n");}
    ;
PARA_LIST: PARA {printf("(paralist->para)\n");}
    | PARA_LIST PARA {printf("(paralist->paralist para)\n");}
    ;
PARA_CONTENT: {printf("(paracontent-><empty>)\n");}
    | TEXT {printf("(paracontent->text)\n");}
    | PARA_CONTENT NEWLINE TEXT {printf("(paracontent->paracontent newline text)\n");}
    ;
PARA: PARA_CONTENT NEWLINE {printf("(para->paracontent newline)\n");}
    | IND_PARA_CONTENT NEWLINE {printf("(para->indparac newline)\n");}
    | PARA NEWLINE {printf("(para->para newline)\n");}
    | ULIST {printf("(para->ulist)\n");}
    | OLIST {printf("(para->olist)\n");}
    | TABLE {printf("(para->table)\n");}
    | BLOCK {printf("(para->block)\n");}
    | PARA_CONTENT ENDFILE {printf("(para->endfile)\n");}
    ; 
ULIST: UITEM {printf("(ulist->uitem)\n");}
    | ULIST UITEM {printf("(ulist->ulist uitem)\n");}
    ;
UITEM: UL TEXT NEWLINE {printf("(uitem->ul text newline)\n");}
    ;
OLIST: OITEM  {printf("(olist->oitem)\n");}
    | OLIST OITEM  {printf("(olist->olist oitem)\n");}
    ;
OITEM: LI TEXT NEWLINE {printf("(oitem->li text newline)\n");}
    ;

NCH: CH {printf("(nch->ch)\n");}
    | ES_CH {printf("(nch->ch_es)\n");}
    | LINK {printf("(nch->link)\n");}
    | IMG {printf("(nch->img)\n");}
    ;
NTEXT: NCH {printf("(ntext->nch)\n");}
    | NTEXT NCH {printf("(ntext->ntext nch)\n");}
    ;
TEXT: NTEXT {printf("(text->ntext)\n");}
    | INL_QUOTE {printf("(text->inl_quote)\n");}
    | TEXT INL_QUOTE {printf("(text->text inl_quote)\n");}
    | TEXT NTEXT {printf("(text->text ntext)\n");}
    ;
INL_QUOTE: INL_Q NTEXT INL_Q {printf("(inl_quote->inl_q ntext inl_quote)\n");}
    ;
IND_PARA_CONTENT: IND TEXT {printf("(indparac->ind text)\n");}
    | IND_PARA_CONTENT NEWLINE IND TEXT {printf("(indparac->indparac newline ind text)\n");}
    ;
TABLE: TROW TNEWLINE  {printf("(table->trow tnewline)\n");}
    | TROW_SEP TNEWLINE {printf("(table->trow_s tnewline)\n");}
    | TABLE TROW TNEWLINE {printf("(table->table trow tnewline)\n");}
    | TABLE TROW_SEP TNEWLINE {printf("(table->table trow_s tnewline)\n");}
    ;
TROW: TSEP TDATA TSEP {printf("(trow->tsep tdata tsep)\n");}
    | TROW TDATA TSEP {printf("(trow->trow tdata tsep)\n");}
    ;
TROW_SEP: TSEP TLINE TSEP {printf("(trow_s->tsep tline tsep)\n");}
    | TROW_SEP TLINE TSEP  {printf("(trow_s->trow_s tline tsep)\n");}
    ;
TDATA: TCH {printf("(tdata->tch)\n");}
    | TCH_ES {printf("(tdata->tches)\n");}
    | TDATA TCH {printf("(tdata->tdata tch)\n");}
    | TDATA TCH_ES {printf("(tdata->tdata tches)\n");}
    ;
%%
int main(){
    yyparse();
}
