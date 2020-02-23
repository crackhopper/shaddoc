#pragma once
extern "C" int yylex();
extern "C" int yyparse();
void yyerror(const char *s);
#include <string>
enum HeadlineType{
    H1,
    H2
};
struct Headline{
    std::string name;
    HeadlineType type;
};
struct Block{
    std::string language;
    std::string content;
};
struct Text{
    std::string content;
};

Headline* newHeadline(HeadlineType type, const char* _start);
Block* newBlock(const char* _start);
Text* newText(const char* _start);