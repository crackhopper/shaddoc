#include <iostream>
#include <istream>
#include <streambuf>
#include <regex>
#include <cctype>
#include <cstdio>
using namespace std;
// 64k use as buffer
#define MAX_BUF 65536
// max read 32k per line
#define MAX_LINE_LENGTH 32728
#define PARSE_LINE_TOO_LONG_ERROR(MAX_LEN) "line too long, max len is "#MAX_LEN
#define BUFFER_OVERFLOW_ERROR(MAX_LEN) "buffer overflow, bufsize is "#MAX_LEN
#define TAB_SPACES "    "
void replaceCh(char* startp, char* endp, char ch, const char* toreplace){
    int chcount = 0;
    for(char* p = startp; p!=endp; ++p){
        if(*p==ch) ++chcount;
    }
    if(chcount>0){
        // old last element
        char* o_last = endp-1;
        // move end pointer
        endp+=chcount*(strlen(toreplace)-1);
        *endp='\0';
        for(char* p=endp-1;p!=startp-1;){
            if(*o_last!=ch) {// just copy
                *p-- = *o_last--;
            }else{
                o_last--;
                // replace
                for(const char* psub=toreplace; *psub!='\0';){
                    *p-- = *psub++;
                }
            }
        }
    }
}
int safeGetline(FILE* stream, char* t, int maxLen)
{
    int curPos=0;
    int readCount=0;
    for(;;) {
        int c = fgetc(stream);
        ++readCount;
        int lookahead;
        if(curPos>=MAX_BUF-2) {
            throw BUFFER_OVERFLOW_ERROR(MAX_BUF-2);
        }
        if(readCount>=maxLen){
            throw PARSE_LINE_TOO_LONG_ERROR(maxLen);
        }
        switch (c) {
        case '\n':
            t[curPos] = '\n'; ++curPos;
            t[curPos] = '\0'; ++curPos;
            return curPos-1;
        case '\r':
            lookahead = fgetc(stream);
            ++readCount;
            if(lookahead!='\n'){
                --readCount;
                ungetc(lookahead, stream);
            }
            t[curPos] = '\n'; ++curPos;
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
    char buf[MAX_BUF];
    regex end_with_two_more_spaces("\\s{2,}\n$");
    regex end_with_space("(\\t|\\ )\n$");
    regex multiple_spaces("(\\t|\\ ){2,}");
    int num = 0;
    char* startp = nullptr;
    char* endp = nullptr;
    FILE* infile = stdin;
    FILE* outfile = stdout;
    bool detectEmptyLine = false;
    while(num=safeGetline(infile, buf, MAX_LINE_LENGTH)){
        // filter trailing spaces
        endp = regex_replace(buf, buf, buf+num, end_with_two_more_spaces, "\n\n");
        *endp = '\0'; // enclose string
        endp = regex_replace(buf, buf, endp, end_with_space, "");
        *endp = '\0'; // enclose string
        // printf("trim end result: '%s'\n",buf);
        // merge multiple empty lines
        detectEmptyLine=(buf[0]=='\n');
        if(detectEmptyLine){
            // printf("found empty line: '%s'\n", buf);
            while(detectEmptyLine){
                num=safeGetline(infile, buf, MAX_LINE_LENGTH);
                endp = regex_replace(buf, buf, buf+num, end_with_two_more_spaces, "\n\n");
                *endp = '\0';
                detectEmptyLine=(buf[0]=='\n');
                // printf("detect empty line %d: '%s'\n", detectEmptyLine ,buf);
            }
            // printf("end emptylines\n");
            fputc('\n', outfile); 
        } 
        // merge multiple spaces
        // spaces from line head should not be merged!!
        startp = find_if(buf, endp, [](char x){
            return !isspace(int(x));
        });
        if(startp!=endp){
            endp = regex_replace(startp, startp, endp, multiple_spaces, " ");
        }
        *endp = '\0';
        // printf("space merged : '%s'\n", buf);
        // replace tab with spaces
        replaceCh(startp, endp, '\t', TAB_SPACES);
        fputs(buf, outfile);
        fflush(outfile);
    }
    fputc('\n', outfile); 
    return 0;
}

