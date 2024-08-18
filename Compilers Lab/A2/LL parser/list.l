%{
#define ID 1
#define NUM 2
#define OP 3
#define LP 4
#define RP 5
#define ARG 6
%}

space [ \t\n]
spaces {space}+

alphabet [a-zA-Z]
IDl {alphabet}[a-zA-Z0-9]*

LeftP "("
RightP ")"

Operator [-+*/%]

Num [-+]?[0-9]+

ignore .

%%
{spaces} { }
{Num} {return NUM;}
{Operator} {return OP;}
{IDl} {return ID;}
{LeftP} {return LP;}
{RightP} {return RP;}
%%