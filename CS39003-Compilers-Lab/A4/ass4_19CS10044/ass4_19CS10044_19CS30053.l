%{
//    COMPILERS LABORATORY CS39003
//    ASSIGNMENT O4 -- Parser for tinyC
//    Semester O5 (Autumn 2021-22)
//    Group Members :	Hritaban Ghosh (19CS30053)
//  					Nakul Aggarwal (19CS10044)

    #include "stdio.h"
    #include "y.tab.h"
    void yyerror ( char * s ) ;
%}

%x ML_COMMENT 
%x SL_COMMENT
KW_SET1         	"auto"|"break"|"case"|"char"|"const"|"continue"|"default"|"do"|"double"
KW_SET2         	"else"|"enum"|"extern"|"float"|"for"|"goto"|"if"|"inline"|"int"|"long"|"typedef"
KW_SET3         	"register"|"restrict"|"return"|"short"|"signed"|"sizeof"|"static"|"struct"|"switch"
KW_SET4         	"union"|"unsigned"|"void"|"volatile"|"while"|"_Bool"|"_Complex"|"_Imaginary"
KEYWORD         	{KW_SET1}|{KW_SET2}|{KW_SET3}|{KW_SET4}
ID          		[_a-zA-Z][_a-zA-Z0-9]*
INT_CONST       	[1-9][0-9]*|[0]+
DIGIT_SEQ       	[0-9]+
FRAC_CONST      	{DIGIT_SEQ}\.{DIGIT_SEQ}|{DIGIT_SEQ}\.|\.{DIGIT_SEQ}
SIGN_OPT        	[-+]?
EXPO_PART       	[eE]{SIGN_OPT}{DIGIT_SEQ}
FLT_CONST       	{FRAC_CONST}{EXPO_PART}|{DIGIT_SEQ}{EXPO_PART}|{FRAC_CONST}
ENUM_CONST      	{ID}
ESC_SEQ         	"\\\'"|"\\\""|"\\\?"|"\\"|"\a"|"\b"|"\f"|"\n"|"\r"|"\t"|"\v"
C_CHAR          	[^\'\n\\]|{ESC_SEQ}
C_CHAR_SEQ      	{C_CHAR}+
CHAR_CONST      	\'{C_CHAR_SEQ}\'
S_CHAR          	[^\"\\\n]|{ESC_SEQ}
S_CHAR_SEQ      	{S_CHAR}+
STRING_LIT      	\"({S_CHAR_SEQ})?\"
WS              	[ \t]
PUNC_SET1           "("|"]"|"["|")"|"{"|"}"|"."|"->"|"++"|"--"|"&"|"*"|"+"|"-"|"~"|"!"|"/"|"%"|"<<"|">>"|"<"|">"|"<="|">="|"=="|"!="|"^"|"|"|"&&"|"||"|"?"|":"|";"|"..."|"="|"*="|"/="|"%="|"+="|"-="|"<<="|">>="|"&="|"^="|"|="|","|"#"
PUNC_SET2       	"["|"]"|"->"|"++"|"--"|"<<"|">>"|"<="|">="|"=="|"!="|"&&"|"||"
PUNC_SET3       	"..."|"*="|"/="|"%="|"+="|"-="|"<<="|">>="|"&="|"^="|"|="
PUNC          		{PUNC_SET1}|{PUNC_SET2}|{PUNC_SET3}

%%

"auto"          { return AUTO ; }
"break"         { return BREAK ; }
"case"          { return CASE ; }
"char"          { return CHAR ; }
"const"         { return CONST ; }
"continue"      { return CONTINUE ; }
"default"       { return DEFAULT ;  }
"do"            { return DO ; }
"double"        { return DOUBLE ; } 
"else"          { return ELSE ; }
"enum"          { return ENUM ; }
"extern"        { return EXTERN ; }
"float"         { return FLOAT ; }
"for"           { return FOR ; }
"goto"          { return GOTO ; }
"if"            { return IF ; }
"inline"        { return INLINE ; }
"int"           { return INT ; }
"long"          { return LONG ; }
"typedef"       { return TYPEDEF ; }
"register"      { return REGISTER ; }
"restrict"      { return RESTRICT ; }
"return"        { return RETURN ; }
"short"         { return SHORT ; }
"signed"        { return SIGNED ; }
"sizeof"        { return SIZEOF ; }
"static"        { return STATIC ; }
"struct"        { return STRUCT ; }
"switch"        { return SWITCH ; }
"union"         { return UNION ; }
"unsigned"      { return UNSIGNED ; }
"void"          { return VOID ; }
"volatile"      { return VOLATILE ; }
"while"         { return WHILE ; }
"_Bool"         { return _BOOL ; }
"_Complex"      { return _COMPLEX ; }
"_IMAGINARY"    { return _IMAGINARY ; }

{ID}            { return IDENTIFIER ; }
{STRING_LIT}    { return STRING_LITERAL ; }
{INT_CONST}     { return INTEGER_CONST ; }
{FLT_CONST}     { return FLOAT_CONST ; }
{CHAR_CONST}    { return CHAR_CONST ; }
{ENUM_CONST}    { return ENUMERATION_CONST ; }
"\n"			{ printf("\n"); }
{WS}           

<INITIAL>"/*"           { BEGIN(ML_COMMENT) ; }
<ML_COMMENT>"/*"        { yyerror("multiline comment cannot be nested") ; }
<ML_COMMENT><<EOF>>     { BEGIN(INITIAL) ; yyerror("multiline comment was not closed") ; }
<ML_COMMENT>[^*/\n]*    
<ML_COMMENT>"/"[^*/\n]* 
<ML_COMMENT>"*"[^*/\n]* 
<ML_COMMENT>\n     		
<ML_COMMENT>"*/"      	{ BEGIN(INITIAL) ; }
<INITIAL>"//"           { BEGIN(SL_COMMENT) ; }
<SL_COMMENT>[^\n]*      
<SL_COMMENT>\n          { BEGIN(INITIAL) ; }
<SL_COMMENT><<EOF>>     { BEGIN(INITIAL) ; }

"["                         { return '[' ; }
"]"                         { return ']' ; }
"("                         { return '(' ; }
")"                         { return ')' ; }
"{"                         { return '{' ; }
"}"                         { return '}' ; }
"."                         { return '.' ; }
"->"                        { return ARROW_OP ; } 
"++"                        { return UNARY_INCREMENT_OP ; }
"--"                        { return UNARY_DECREMENT_OP ; }
"&"                         { return '&' ; }
"*"                         { return '*' ; }
"+"                         { return '+' ; }
"-"                         { return '-' ; }
"~"                         { return '~' ; }
"!"                         { return '!' ; }
"/"                         { return '/' ; }
"%"                         { return '%' ; }
">>"                        { return RIGHT_SHIFT_OP ; }
"<<"                        { return LEFT_SHIFT_OP ; }
"<"                         { return '<' ; }
">"                         { return '>' ; }
"<="                        { return LESS_THAN_EQUAL_OP ; }
">="                        { return GREATER_THAN_EQUAL_OP ; }
"=="                        { return EQUALITY_OP ; }
"!="                        { return INEQUALITY_OP ; } 
"^"                         { return '^' ; } 
"|"                         { return '|' ; }
"||"                        { return LOGICAL_OR_OP ; }
"&&"                        { return LOGICAL_AND_OP ; }
"?"                         { return '?' ; }
":"                         { return ':' ; }
";"                         { return ';' ; }
"..."                       { return ELLIPSIS ; }
"="                         { return '=' ; }
"*="                        { return MULT_ASSIGN_OP ; }
"/="                        { return DIV_ASSIGN_OP ; }
"%="                        { return MOD_ASSIGN_OP ; }
"+="                        { return ADD_ASSIGN_OP ; }
"-="                        { return SUB_ASSIGN_OP ; }
"<<="                       { return LSHIFT_ASSIGN_OP ; }
">>="                       { return RSHIFT_ASSIGN_OP ; }
"&="                        { return BITW_AND_ASSIGN_OP ; }
"^="                        { return BITW_XOR_ASSIGN_OP ; }
"|="                        { return BITW_OR_ASSIGN_OP ; }
","                         { return ',' ; }
"#"                         { return '#' ; }

%%
