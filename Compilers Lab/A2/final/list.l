%{
# define ID 1
# define NUM 2
# define OP 3
# define LP 4
# define RP 5
# define ERROR 6
# define NL 7 
# define INV 8
%}

space [ \t]
spaces {space}+

newline [\n]

id [a-zA-Z][a-zA-Z0-9]*

number [-+]?[0-9]+

lp "("

rp ")"

op [-+*/%]



error .

%%
{spaces} { }
{id} {return ID;}
{number} {return NUM;}
{op} {return OP;}
{lp} {return LP;}
{rp} {return RP;}
{error} {return ERROR;}
{newline} {return NL;}

"=="|"<="|">="|"<"|">"|"&&"|"||"|"!"|"~"|"&"|"|"|"^"|"<<"|">>"|"++"|"--"|"="|"+="|"-="|"*="|"/="|"%="|"&="|"|="|"^="|"<<="|">>="|","|"::"|"["|"]"|"."|"->"|"?"|":"|"sizeof"|"typeid" { return INV;}
%%




