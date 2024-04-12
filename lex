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
