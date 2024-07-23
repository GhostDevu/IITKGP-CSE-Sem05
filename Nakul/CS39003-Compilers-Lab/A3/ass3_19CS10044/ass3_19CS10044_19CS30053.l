
%{
/*
  COMPILERS LABORATORY CS39003
  ASSIGNMENT O3 -- Lexer for tinyC
  Semester O5 (Autumn 2021-22)
  Group Members :   Hritaban Ghosh (19CS30053)
                    Nakul Aggarwal (19CS10044)
*/

#define __KEYWORD 41
#define __IDENTIFIER 42
#define __INTEGER_CONST 43
#define __FLOAT_CONST 44
#define __CHARACTER_CONST 45
#define __ENUMERATION_CONST 46
#define __STRING_LITERAL 47
#define __PUNCTUATOR 48
#define __WHITESPACE 49
#define __MULTI_LINE_COMMENT 50
#define __SINGLE_LINE_COMMENT 51
#define __MULTI_LINE_COMMENT_BEGIN 52
#define __MULTI_LINE_COMMENT_END 53
#define __SINGLE_LINE_COMMENT_BEGIN 54
#define __SINGLE_LINE_COMMENT_END 55
#define __NESTED_MULTI_LINE_COMMENT 101
#define __MULTILINE_COMMENT_NOT_CLOSED 102
%}

KW_SET1         	"auto"|"break"|"case"|"char"|"const"|"continue"|"default"|"do"|"double"
KW_SET2         	"else"|"enum"|"extern"|"float"|"for"|"goto"|"if"|"inline"|"int"|"long"|"typedef"
KW_SET3         	"register"|"restrict"|"return"|"short"|"signed"|"sizeof"|"static"|"struct"|"switch"
KW_SET4         	"union"|"unsigned"|"void"|"volatile"|"while"|"_Bool"|"_Complex"|"_Imaginary"
KEYWORD         	{KW_SET1}|{KW_SET2}|{KW_SET3}|{KW_SET4}
ID          		  [_a-zA-Z][_a-zA-Z0-9]*
INT_CONST       	[1-9][0-9]*
DIGIT_SEQ       	[0-9]+
FRAC_CONST      	{DIGIT_SEQ}\.{DIGIT_SEQ}|{DIGIT_SEQ}\.|\.{DIGIT_SEQ}
SIGN_OPT        	[-+]?
EXPO_PART       	[eE]{SIGN_OPT}{DIGIT_SEQ}
FLT_CONST       	{FRAC_CONST}{EXPO_PART}|{DIGIT_SEQ}{EXPO_PART}|{FRAC_CONST}
ENUM_CONST      	{ID}
ESC_SEQ         	"\\\'"|"\\\""|"\?"|"\\"|"\a"|"\b"|"\f"|"\n"|"\r"|"\t"|"\v"
C_CHAR          	[^\'\n\\]|{ESC_SEQ}
C_CHAR_SEQ      	{C_CHAR}+
CHAR_CONST      	\'{C_CHAR_SEQ}\'
S_CHAR          	[^\"\\\n]|{ESC_SEQ}
S_CHAR_SEQ      	{S_CHAR}+
STRING_LIT      	\"({S_CHAR_SEQ})?\"
WS              	[ \t\n]
PUNC_SET1       	[(){}.&*+-~!/%<>^|?:;=,#]
PUNC_SET2       	"["|"]"|"->"|"++"|"--"|"<<"|">>"|"<="|">="|"=="|"!="|"&&"|"||"
PUNC_SET3       	"..."|"*="|"/="|"%="|"+="|"-="|"<<="|">>="|"&="|"^="|"|="
PUNC          		{PUNC_SET1}|{PUNC_SET2}|{PUNC_SET3}

%x ML_COMMENT 
%x SL_COMMENT

%%

{KEYWORD}       		{ return __KEYWORD; }
{ID}            		{ return __IDENTIFIER; }
{PUNC}          		{ return __PUNCTUATOR; }
{STRING_LIT}    		{ return __STRING_LITERAL; }	
{INT_CONST}     		{ return __INTEGER_CONST; }
{FLT_CONST}     		{ return __FLOAT_CONST; }
{ENUM_CONST}        { return __ENUMERATION_CONST; }
{CHAR_CONST}    		{ return __CHARACTER_CONST; }
{WS}            		{ return __WHITESPACE; }
<INITIAL>"/*"           { BEGIN(ML_COMMENT);	return __MULTI_LINE_COMMENT_BEGIN;	}
<ML_COMMENT>"/*"        { return __NESTED_MULTI_LINE_COMMENT; }
<ML_COMMENT><<EOF>>     { BEGIN(INITIAL); return __MULTILINE_COMMENT_NOT_CLOSED; }
<ML_COMMENT>[^*/\n]*    { return __MULTI_LINE_COMMENT; }
<ML_COMMENT>"/"[^*/\n]* { return __MULTI_LINE_COMMENT; }
<ML_COMMENT>"*"[^*/\n]* { return __MULTI_LINE_COMMENT; }
<ML_COMMENT>\n          { return __MULTI_LINE_COMMENT; }
<ML_COMMENT>"*/"      	{ BEGIN(INITIAL); return __MULTI_LINE_COMMENT_END; }
<INITIAL>"//"           { BEGIN(SL_COMMENT);  return __SINGLE_LINE_COMMENT_BEGIN;	}
<SL_COMMENT>[^\n]*      { return __SINGLE_LINE_COMMENT; }
<SL_COMMENT>\n          { BEGIN(INITIAL); return __SINGLE_LINE_COMMENT_END; }
<SL_COMMENT><<EOF>>     { BEGIN(INITIAL); return __SINGLE_LINE_COMMENT_END; }

%%
