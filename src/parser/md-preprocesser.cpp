#include <iostream>
#include <istream>
#include <streambuf>
#include <regex>
#include <cctype>
#include <cstdio>
using namespace std;
#define MAX_LINE_LENGTH 65535
#define _TOO_LONG_ERROR(MAX_LEN) "line too long, max len is "#MAX_LEN
#define LINE_TOO_LONG_ERROR() _TOO_LONG_ERROR(MAX_LINE_LENGTH)
int safeGetline(FILE* stream, char* t, int maxLen)
{
    int curPos=0;
    for(;;) {
        int c = fgetc(stream);
        int lookahead;
        if(curPos>=maxLen-1) {
            throw LINE_TOO_LONG_ERROR();
        }
        switch (c) {
        case '\n':
            t[curPos] = '\0'; ++curPos;
            return curPos-1;
        case '\r':
            lookahead = fgetc(stream);
            if(lookahead!='\n'){
                ungetc(lookahead, stream);
            }
            t[curPos] = '\0'; ++curPos;
            return curPos-1;
        case EOF:
            // Also handle the case when the last line has no line ending
            t[curPos] = '\0'; ++curPos;
            return curPos-1;
        default:
            t[curPos] = (char)c; curPos++;
        }
    }
}

int main(int argc, char* argv[]){
    char buf[MAX_LINE_LENGTH];
    regex end_with_two_more_spaces("\\s{2}\\s*$");
    regex multiple_spaces("\\s\\s+");
    int num = 0;
    char* endp = nullptr;
    FILE* infile = stdin;
    FILE* outfile = stdout;
    bool detectEmptyLine = false;
    while(true){
        num=safeGetline(infile, buf, MAX_LINE_LENGTH);
        // filter trailing spaces
        endp = regex_replace(buf, buf, buf+num, end_with_two_more_spaces, "\n");
        *endp = '\0'; // enclose string
        // printf("trim end result: '%s'\n",buf);
        // merge multiple empty lines
        detectEmptyLine=(buf[0]=='\n'||buf[0]=='\0');
        if(detectEmptyLine){
            // printf("found empty line: '%s'\n", buf);
            while(detectEmptyLine){
                num=safeGetline(infile, buf, MAX_LINE_LENGTH);
                endp = regex_replace(buf, buf, buf+num, end_with_two_more_spaces, "\n");
                *endp = '\0';
                detectEmptyLine=(buf[0]=='\n'||buf[0]=='\0');
                // printf("detect empty line %d: '%s'\n", detectEmptyLine ,buf);
            }
            fputc('\n', outfile); 
            // printf("end emptylines\n");
        } 
        // merge multiple spaces
        endp = regex_replace(buf, buf, endp, multiple_spaces, " ");
        *endp = '\0';
        // printf("space merged : '%s'\n", buf);
        // 默认追加一个换行
        fputs(buf, outfile);
        fputc('\n', outfile); 
        fflush(outfile);
        if(feof(infile)) {
            break;
        }
    }
    return 0;
}