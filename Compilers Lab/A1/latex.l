%{

#define DMF 1
#define MF 2
#define CMD 3
#define BGN 4
#define COM 5
#define END 6
#define ALP 7
#define MDO 8
#define MDF 9
%}


space [ \t\n]
spaces {space}+

single_line_comment \%.*"\\n"?

alphabet [a-zA-Z]
alphabets {alphabet}+

displayed_math_formula "$$"
math_formula "$"

active_char "~"
alphabet_commands \\{alphabets}
special_char_commands \\[ -~]{-}[a-zA-Z~]

env_space \{[a-zA-Z]*\}
env_begin \\begin{spaces}?\{
env_end \\end{spaces}?{env_space}

display_math_2 \\\[
display_math_3 \\\]

ignore .

%%
{spaces}  { }
{single_line_comment} { return COM;}
{displayed_math_formula} {return DMF;}
{math_formula} {return MF;}
{display_math_2} {return MDO;}
{display_math_3} {return MDF;}

{env_begin} {return BGN;}
{env_end} { return END;}
{alphabets} {return ALP;}

{alphabet_commands} {return CMD;}
{special_char_commands} {return CMD;}
{active_char} {return CMD;}
{ignore} { }
%%