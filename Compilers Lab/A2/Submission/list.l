%{

#define ID 1
#define OP 2
#define NUM 3

    
%}

space [ \t\n]
spaces {space}+

lp "("
rp  ")"

alphabet [a-zA-Z]
id {alphabet}[a-zA-Z0-9]*

num [-+]?[0-9]+

op [-+*/%]

ignore .

%%

%%