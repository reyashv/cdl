lex ex7.lex
gcc –o ex7 lex.yy.c –lfl
./ex7  filename

flex byacc bison bison++ byacc-j
lex lex1.l
cc lex.yy.c -lfl
./a.out

flex hello.l
gcc lex.yy.c
a.exe

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



flex byacc bison bison++ byacc-j
lex lex1.l
cc lex.yy.c -lfl
./a.out


1. Write a lex program to add line numbers to the given file and display the same in the output.

%{
/*
*/
int lineno=1;
%}
line .*\n
%%
{line} { printf("%5d %s",lineno++,yytext); }
%%
main()
{
yylex();
return 0;
}

#----------------------------------------------

2. Write a lex program to extract only comment lines from a C program and display the
same on output.

%{
%}
comment \/\*.*\*\/
%%
{comment} ECHO;
%%
main(int argc, char*argv[])
{
extern FILE *yyin;
yyin=fopen(argv[1],"r");
yylex();
printf("\n");
return 0;
}

#------------------------------------------------

3. Write a lex program to replace sequence of blank spaces with a single blank space.
%{
%}
ws [ \t]
%%
{ws}+ {printf(" "); }
. {printf("%s",yytext);}
%%
main(int argc, char*argv[])
{
extern FILE *yyin;
yyin=fopen(argv[1],"r");
yylex();
printf("\n");
return 0;
}

#--------------------------------------

4. Write a lex program to count the occurrence of a word “printf” in a C program.

%{
int count=0;
%}
%%
"printf" {count++;}
. ;
%%
main(int argc, char*argv[])
{
extern FILE *yyin;
yyin=fopen(argv[1],"r");
yylex();
printf("No of Occurrences=%d\n",count);
return 0;
}

#-------------------------------------------

5. Write a lex program to remove all the occurrences of “printf” from a C program.

%{
%}
%%
"printf"
. ECHO;
%%
#-------------------------------------------

6. Write a lex program to extract all html tags in the given file.
%{
%}
%%
"<"[^>]*> {printf("%s\n", yytext); }
. ;
%%
main(int argc, char*argv[])
{
extern FILE *yyin;
yyin=fopen(argv[1],"r");
yylex();
printf("\n");
return 0;
}


#-------------------------------------------

7. Write a lex program to remove all html tags in the given file.

%{
%}
%%
"<"[^>]*> ;
. { printf("%c", yytext[0]); }
%%
int main(int argc, char* argv[]) {
    FILE *yyin;
    yyin = fopen(argv[1], "r");
    if(yyin == NULL) {
        fprintf(stderr, "Error opening file.\n");
        return 1;
    }
    yyin = stdin;
    yylex();
    fclose(yyin);
    return 0;
}

#-----------------------------------------------
8. Write a lex program to check whether the given E-mail id is correct or not.
% 
{ 
  int flag = 0; % 
} % 
% [a - z.0 - 9 _] + @[a - z] + ".com" | ".in"
flag = 1; % 
% 
main() { 
  yylex(); 
  if (flag == 1) 
    printf("Accepted"); 
  else
    printf("Not Accepted"); 
} 

#-------------------------------------------------
9. IP Address Checker
%{
#include <stdio.h>
%}

DIGIT [0-9]
OCTET {DIGIT}|([1-9]{DIGIT})|([1][0-9]{2})|([2][0-4][0-9])|([2][5][0-5])
IPADDRESS {OCTET}("."{OCTET}){3}

%%

{IPADDRESS} {
    int octet1, octet2, octet3, octet4;
    sscanf(yytext, "%d.%d.%d.%d", &octet1, &octet2, &octet3, &octet4);
    if (octet1 >= 1 && octet1 <= 126)
        printf("Class A IP Address\n");
    else if (octet1 >= 128 && octet1 <= 191)
        printf("Class B IP Address\n");
    else if (octet1 >= 192 && octet1 <= 223)
        printf("Class C IP Address\n");
    else if (octet1 >= 224 && octet1 <= 239)
        printf("Class D IP Address\n");
    else if (octet1 >= 240 && octet1 <= 255)
        printf("Class E IP Address\n");
    else
        printf("Invalid IP Address\n");
}

%%

int main() {
    yylex();
    return 0;
}

#-------------------------------
10. MAC Ad
11. Lex program to count the number of integers and floating-point numbers in an input file
%{
#include <stdio.h>
int int_count = 0;
int float_count = 0;
%}

%%
[0-9]+                         { int_count++; }
[0-9]+"."[0-9]+                { float_count++; }
[ \t\n]                        ; /* Ignore whitespace and newline characters */
.                              ; /* Ignore any other characters */
%%

int main() {
    yylex();
    printf("Number of integers: %d\n", int_count);
    printf("Number of floating-point numbers: %d\n", float_count);
    return 0;
}

>lex number_counter.l
>gcc lex.yy.c -o number_counter -ll
>./number_counter < input_file.txt

#--------------------------
12. Lex to find longets and shortest word

%{
#include <stdio.h>
#include <string.h>
#define MAX_LENGTH 1000
char smallest_word[MAX_LENGTH];
char longest_word[MAX_LENGTH];
%}

%option noyywrap

%%
[a-zA-Z]+ {
    int length = strlen(yytext);
    if (strlen(smallest_word) == 0 || length < strlen(smallest_word)) {
        strcpy(smallest_word, yytext);
    }
    if (strlen(longest_word) == 0 || length > strlen(longest_word)) {
        strcpy(longest_word, yytext);
    }
}
. ;

%%

int main() {
    yylex();
    printf("Smallest word: %s\n", smallest_word);
    printf("Longest word: %s\n", longest_word);
    return 0;
}

#----------------------------------
13. Write a lex program to read an input program and display the list of strings enclosed in
double quotes and characters given in single quotes.

%{
#include <stdio.h>
%}

%%
\"[^\"\n]*\" {
    printf("String: %s\n", yytext);
}

\'[^\'\n]*\' {
    printf("Character: %s\n", yytext);
}

. ;

%%

int main() {
    yylex();
    return 0;
}

#-----------------------------------------

14. Write a lex program to recognize identifiers and keywords for C.

%{
#include <stdio.h>
#include <string.h>
%}

%option noyywrap

%%
int|char|float|double|void|long|short|signed|unsigned|auto|break|case|
const|continue|default|do|else|enum|extern|for|goto|if|register|return|
sizeof|static|struct|switch|typedef|union|volatile|while {
    printf("Keyword: %s\n", yytext);
}

[a-zA-Z_][a-zA-Z0-9_]* {
    printf("Identifier: %s\n", yytext);
}

. ;

%%

int main() {
    yylex();
    return 0;
}

#---------------------------------------------
