lex ex7.lex
gcc –o ex7 lex.yy.c –lfl
./ex7  filename

%{
#include<stdlib.h>
#include<stdio.h>
int emptyline=0;
%}

SPACES [ \t]
eol \n

%%
{SPACES}+   {printf(" "); }
\n|. {
 	char c=yytext[0];
	if(!isspace(c))  
	{
		emptyline=1;
		putchar(c);
	}
	if(c=='\n')
	{
		if(emptyline)putchar(c);
		emptyline=0;
	}
     }
%%

main(int argc, char*argv[])
{
extern FILE *yyin;
yyin=fopen(argv[1],"r");
yylex();
printf("\n");
return 0;
}

--

%%
"/*" {char c;
int done=0;
ECHO;
do
{
while((c=input())!='*') putchar(c);
putchar(c);
while((c=input())=='*') putchar(c);
putchar(c);
if(c=='/') done=1;
} while(!done);
}
. ;
\n ;
%%



#add line nos
%{
#include <stdio.h>
int line_num = 1;
%}

%%
\n { printf("%d: %s", line_num++, yytext); }
.  { printf("%d: %s", line_num, yytext); }
%%

int yywrap() {
    return 1;
}

int main(int argc, char *argv[]) {
    if (argc != 2) {
        printf("Usage: %s <input_file>\n", argv[0]);
        return 1;
    }

    FILE *input_file = fopen(argv[1], "r");
    if (!input_file) {
        perror("Error");
        return 1;
    }

    yyin = input_file;
    yylex();
    fclose(input_file);

    return 0;
}
#---------------------------------------------------------------------------
#only comment lines from c
%{
#include <stdio.h>
int inside_comment = 0;
%}

%%

"/*"    { inside_comment = 1; }
"*/"    { inside_comment = 0; }
"//"    { if (!inside_comment) printf("%s\n", yytext); }
.       { if (inside_comment) printf("%s\n", yytext); }

%%

int main(int argc, char *argv[]) {
    if (argc != 2) {
        printf("Usage: %s <input_file>\n", argv[0]);
        return 1;
    }

    FILE *input_file = fopen(argv[1], "r");
    if (!input_file) {
        perror("Error");
        return 1;
    }

    yyin = input_file;
    yylex();
    fclose(input_file);

    return 0;
}
#---------------------------------------------------------------------------
#replace multiple blanks with single blank
%{
#include <stdio.h>
%}

%%
[ \t]+     printf(" ");
.          printf("%s", yytext);
%%

int main(int argc, char *argv[]) {
    if (argc != 2) {
        printf("Usage: %s <input_file>\n", argv[0]);
        return 1;
    }

    FILE *input_file = fopen(argv[1], "r");
    if (!input_file) {
        perror("Error");
        return 1;
    }

    yyin = input_file;
    yylex();
    fclose(input_file);

    return 0;
}
#---------------------------------------------------------------------------
#count occurances of printf
%{
#include <stdio.h>
int printf_count = 0;
%}

%%

"printf"    { printf_count++; }

%%

int main(int argc, char *argv[]) {
    if (argc != 2) {
        printf("Usage: %s <input_file>\n", argv[0]);
        return 1;
    }

    FILE *input_file = fopen(argv[1], "r");
    if (!input_file) {
        perror("Error");
        return 1;
    }

    yyin = input_file;
    yylex();
    fclose(input_file);

    printf("Occurrences of \"printf\" in the file: %d\n", printf_count);

    return 0;
}
#---------------------------------------------------------------------------
#remove all occurances of printf
%{
#include <stdio.h>
%}

%%
printf      /* Remove occurrences of "printf" */
.           printf("%s", yytext);
%%

int main(int argc, char *argv[]) {
    if (argc != 2) {
        printf("Usage: %s <input_file>\n", argv[0]);
        return 1;
    }

    FILE *input_file = fopen(argv[1], "r");
    if (!input_file) {
        perror("Error");
        return 1;
    }

    yyin = input_file;
    yylex();
    fclose(input_file);

    return 0;
}
#---------------------------------------------------------------------------
#html tags
%{
#include <stdio.h>
%}

%%

<.*>     { printf("%s\n", yytext); }

%%

int main(int argc, char *argv[]) {
    if (argc != 2) {
        printf("Usage: %s <input_file>\n", argv[0]);
        return 1;
    }

    FILE *input_file = fopen(argv[1], "r");
    if (!input_file) {
        perror("Error");
        return 1;
    }

    yyin = input_file;
    yylex();
    fclose(input_file);

    return 0;
}
#---------------------------------------------------------------------------
#remove html tags
%{
#include <stdio.h>
int inside_tag = 0;
%}

%%

"<"     { inside_tag = 1; }
">"     { inside_tag = 0; }
[^<>]+  { if (!inside_tag) printf("%s", yytext); }

%%

int main(int argc, char *argv[]) {
    if (argc != 2) {
        printf("Usage: %s <input_file>\n", argv[0]);
        return 1;
    }

    FILE *input_file = fopen(argv[1], "r");
    if (!input_file) {
        perror("Error");
        return 1;
    }

    yyin = input_file;
    yylex();
    fclose(input_file);

    return 0;
}
#---------------------------------------------------------------------------
#ip addr valid or not
%{
#include <stdio.h>
#include <stdlib.h>
%}

%option noyywrap

%%

"exit"|"quit"   exit(0);

"["[0-9]+"."{3}[0-9]+"]"   { printf("Invalid input: IPv6 address not supported.\n"); }
[0-9]+"."{3}[0-9]+          {
                                int octets[4];
                                sscanf(yytext, "%d.%d.%d.%d", &octets[0], &octets[1], &octets[2], &octets[3]);
                                int isValid = 1;
                                int i;
                                for (i = 0; i < 4; i++) {
                                    if (octets[i] < 0 || octets[i] > 255) {
                                        isValid = 0;
                                        break;
                                    }
                                }
                                if (isValid) {
                                    if (octets[0] >= 1 && octets[0] <= 126)
                                        printf("Class: A\n");
                                    else if (octets[0] >= 128 && octets[0] <= 191)
                                        printf("Class: B\n");
                                    else if (octets[0] >= 192 && octets[0] <= 223)
                                        printf("Class: C\n");
                                    else if (octets[0] >= 224 && octets[0] <= 239)
                                        printf("Class: D\n");
                                    else if (octets[0] >= 240 && octets[0] <= 255)
                                        printf("Class: E\n");
                                    else
                                        printf("Invalid IP address.\n");
                                } else {
                                    printf("Invalid IP address.\n");
                                }
                            }
.                           printf("Invalid input: Not an IP address.\n");

%%

int main() {
    yylex();
    return 0;
}
#---------------------------------------------------------------------------
#mac addr valid or not
%{
#include <stdio.h>
#include <string.h>
#include <stdlib.h>
%}

%option noyywrap

%%

"exit"|"quit"   exit(0);

[:xdigit:]{2}"-"[:xdigit:]{2}"-"[:xdigit:]{2}"-"[:xdigit:]{2}"-"[:xdigit:]{2}"-"[:xdigit:]{2} {
                                char mac_address[18];
                                strcpy(mac_address, yytext);

                                // Check if the MAC address is valid
                                int i;
                                for (i = 0; i < strlen(mac_address); i++) {
                                    if ((i + 1) % 3 == 0 && mac_address[i] != '-') {
                                        printf("Invalid MAC address.\n");
                                        return 0;
                                    }
                                    if (((i + 1) % 3 != 0) && !isxdigit(mac_address[i])) {
                                        printf("Invalid MAC address.\n");
                                        return 0;
                                    }
                                }

                                // Extract manufacturer prefix
                                char manufacturer[7];
                                strncpy(manufacturer, mac_address, 6);
                                manufacturer[6] = '\0';

                                printf("MAC address is valid.\nManufacturer: %s\n", manufacturer);
                            }

.                           printf("Invalid input: Not a MAC address.\n");

%%

int main() {
    printf("Enter MAC address: ");
    yylex();
    return 0;
}
#---------------------------------------------------------------------------
#count int and float
%{
#include <stdio.h>
%}

digit       [0-9]
integer     {digit}+
floatnumber {digit}+"."{digit}+

%%

{integer}   { printf("Integer: %s\n", yytext); }
{floatnumber} { printf("Float: %s\n", yytext); }

%%

int main(int argc, char *argv[]) {
    if (argc != 2) {
        printf("Usage: %s <input_file>\n", argv[0]);
        return 1;
    }

    FILE *input_file = fopen(argv[1], "r");
    if (!input_file) {
        perror("Error");
        return 1;
    }

    yyin = input_file;
    yylex();
    fclose(input_file);

    return 0;
}
#---------------------------------------------------------------------------
#recognise numbers in c
%{
#include <stdio.h>
%}

%%

[0-9]+[Ll]?                    { printf("Integer: %s\n", yytext); }
[0-9]*\.[0-9]+[FfLl]?          { printf("Float: %s\n", yytext); }
[0-9]+[Ee][+-]?[0-9]+[FfLl]?   { printf("Float: %s\n", yytext); }
0x[0-9A-Fa-f]+[ULul]?          { printf("Hexadecimal: %s\n", yytext); }

%%

int main() {
    yylex();
    return 0;
}
#---------------------------------------------------------------------------
#identifiers in c
%{
#include <stdio.h>
#include <string.h>
%}

%%

"auto"|"break"|"case"|"char"|"const"|"continue"|"default"|"do"|"double"|"else"|"extern"|
"float"|"for"|"goto"|"if"|"int"|"return"|"sizeof"|"struct"|"void"|"while"  { printf("Keyword: %s\n", yytext); }

[a-zA-Z_][a-zA-Z0-9_]*  { printf("Identifier: %s\n", yytext); }

%%

int main() {
    printf("Enter text (Ctrl+D to exit):\n");
    yylex();
    return 0;
}
#---------------------------------------------------------------------------
#recognise comments
%{
#include <stdio.h>
%}

%%

^"#".*$                 { printf("Single-line preprocessor directive: %s\n", yytext); }
"//"                    { printf("Single-line comment: %s\n", yytext); }
"/*"([^*]|[*]+[^*/])*"*/" { printf("Multi-line comment: %s\n", yytext); }
<INITIAL>"/*"            { BEGIN(MULTI_LINE_COMMENT); }
<INITIAL>\#              { printf("Preprocessor directive: %s\n", yytext); }
.                        ;

<MULTI_LINE_COMMENT>{
    "/*"                  { BEGIN(NESTED_COMMENT); }
    .                     ;
}

<NESTED_COMMENT>{
    "*/"                  { BEGIN(MULTI_LINE_COMMENT); }
    "/*"                  ; // Nested comments are ignored
    .                     ;
}

%%

int main() {
    printf("Enter text (Ctrl+D to exit):\n");
    yylex();
    return 0;
}
#---------------------------------------------------------------------------
#display strings and characters
%{
#include <stdio.h>
%}

%%

\"[^\"\n]*\"       { printf("String: %s\n", yytext); }
\'[^\'\n]*\'       { printf("Character: %s\n", yytext); }

%%

int main() {
    printf("Enter text (Ctrl+D to exit):\n");
    yylex();
    return 0;
}
#---------------------------------------------------------------------------
#replace every letter with letter which comes three pos after it in alpha wrap around z
%{
#include <stdio.h>
%}

%%

[a-zA-Z]    {
                int shift = yytext[0] + 3;
                if (yytext[0] >= 'a' && yytext[0] <= 'z') {
                    if (shift > 'z') {
                        shift = 'a' + (shift - 'z' - 1);
                    }
                } else if (yytext[0] >= 'A' && yytext[0] <= 'Z') {
                    if (shift > 'Z') {
                        shift = 'A' + (shift - 'Z' - 1);
                    }
                }
                printf("%c", shift);
            }
.           { printf("%s", yytext); }

%%

int main() {
    yylex();
    return 0;
}
#---------------------------------------------------------------------------
#find smallest and longest words
%{
#include <stdio.h>
#include <string.h>
%}

%option noyywrap

%%

[a-zA-Z]+ {
    if (strlen(yytext) < strlen(min_word) || !strlen(min_word)) {
        strcpy(min_word, yytext);
    }
    if (strlen(yytext) > strlen(max_word)) {
        strcpy(max_word, yytext);
    }
}

. {
    // Ignore non-alphabetical characters
}

%%

int main() {
    char min_word[100] = "";
    char max_word[100] = "";

    printf("Enter text (Ctrl+D to exit):\n");

    yylex();

    if (!strlen(min_word) && !strlen(max_word)) {
        printf("No words found.\n");
    } else {
        printf("Smallest word: %s\n", min_word);
        printf("Longest word: %s\n", max_word);
    }

    return 0;
}
#---------------------------------------------------------------------------
