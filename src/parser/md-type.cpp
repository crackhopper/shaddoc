#include "md-type.hpp"
#include "stdio.h"
#include "string.h"
#include <algorithm>
#include <iostream> 
using namespace std;
 
inline string& ltrim(string &str) {
    string::iterator p = find_if(str.begin(), str.end(), not1(ptr_fun<int, int>(isspace)));
    str.erase(str.begin(), p);
    return str;
}
 
inline string& rtrim(string &str) {
    string::reverse_iterator p = find_if(str.rbegin(), str.rend(), not1(ptr_fun<int , int>(isspace)));
    str.erase(p.base(), str.end());
    return str;
}

void yyerror(const char *s){printf("error: %s",s);}
using namespace std;
Headline* newHeadline(HeadlineType type, const char* _start){
    auto res = new Headline;
    res->type = type;
    res->name = string(_start);
    rtrim(res->name);
    string stype;
    if(res->type==H1) stype="h1";
    else stype="h2";
    cout<<"new headline: "<< endl
        << "H: "<<stype << endl
        << "name: "<<res->name <<endl;
    return res;
}
Block* newBlock(const char* _start){
    auto res = new Block;
    auto end=strchr(_start, '\n');
    res->language = string(_start, end);
    rtrim(res->language);
    res->content = string(end+1);
    res->content.erase(res->content.end()-3,res->content.end());
    cout<<"new block: "<< endl
        << "language: "<<res->language << endl
        << "content: "<<res->content <<endl;
    return res;
}
Text* newText(const char* _start){
    auto res = new Text;
    res->content = string(_start);
    cout<<"new text: "<< endl
        << "content: "<<res->content <<endl;
    return res;
}