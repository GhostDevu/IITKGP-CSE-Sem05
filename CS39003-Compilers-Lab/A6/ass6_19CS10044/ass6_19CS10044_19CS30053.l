
%{

//    COMPILERS LABORATORY CS39003
//    ASSIGNMENT O6 -- Lexer for tinyC
//    Semester O5 (Autumn 2021-22)
//    Group Members :	Hritaban Ghosh (19CS30053)
//  					Nakul Aggarwal (19CS10044)

    #include "stdio.h"
    #include "string.h"
    #include "ass6_19CS10044_19CS30053_translator.h"
    #include "ass6_19CS10044_19CS30053.tab.h"

	// Size of different data types - Target Machine Dependent
	#define __SIZE_OF_CHAR__ 1
	#define __SIZE_OF_FLOAT__ 8
	#define __SIZE_OF_INT__ 4
	#define __SIZE_OF_VOID__ 0
    
    extern YYSTYPE yylval;
    extern int line;
    int line = 1;
    
    // yyerror for error recovery
	void yyerror ( string ) ;
%}
/* Definitions of Regular Expression */

/* The macro/function yywrap() is called when a lex scanner reaches the end-of-file. It can be used to make your */
/* lexer work with a command line that globs file names or similar use cases. The %option noyywrap generally */
/* causes a lex compatible lexer generator (e.g. lex or flex) to emit a macro version of yywrap() that returns 1, */
/* which causes the lexer to stop lexing when the first end-of-file is reached. */
%option noyywrap

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

"auto"          			{ return AUTO ; }
"break"         			{ return BREAK ; }
"case"          			{ return CASE ; }
"char"          			{ 
								// Set the size of the type according to the target machine and return the token
								yylval.size_of_type = __SIZE_OF_CHAR__ ; 
								return CHAR ; 
							}
"const"         			{ return CONST ; }
"continue"      			{ return CONTINUE ; }
"default"       			{ return DEFAULT ;  }
"do"            			{ return DO ; }
"double"        			{ return DOUBLE ; } 
"else"          			{ return ELSE ; }
"enum"          			{ return ENUM ; }
"extern"        			{ return EXTERN ; }
"float"         			{ 
								// Set the size of the type according to the target machine and return the token
								yylval.size_of_type = __SIZE_OF_FLOAT__ ; 
								return FLOAT ; 
							}
"for"           			{ return FOR ; }
"goto"          			{ return GOTO ; }
"if"           				{ return IF ; }
"inline"        			{ return INLINE ; }
"int"           			{ 
								// Set the size of the type according to the target machine and return the token
								yylval.size_of_type = __SIZE_OF_INT__ ; 
								return INT ; 
							}
"long"          			{ return LONG ; }
"typedef"       			{ return TYPEDEF ; }
"register"      			{ return REGISTER ; }
"restrict"      			{ return RESTRICT ; }
"return"        			{ return RETURN ; }
"short"         			{ return SHORT ; }
"signed"        			{ return SIGNED ; }
"sizeof"        			{ return SIZEOF ; }
"static"       	 			{ return STATIC ; }
"struct"        			{ return STRUCT ; }
"switch"        			{ return SWITCH ; }
"union"         			{ return UNION ; }
"unsigned"      			{ return UNSIGNED ; }
"void"          			{ 
								// Set the size of the type according to the target machine and return the token
								yylval.size_of_type = __SIZE_OF_VOID__ ; 
								return VOID ; 
							}
"volatile"      			{ return VOLATILE ; }
"while"         			{ return WHILE ; }
"_Bool"         			{ return _BOOL ; }
"_Complex"      			{ return _COMPLEX ; }
"_IMAGINARY"    			{ return _IMAGINARY ; }


"\n"						{ /* printf("\n"); */ }
{WS}           				

<INITIAL>"/*"           	{ BEGIN(ML_COMMENT) ; }
<ML_COMMENT>"/*"        	{ yyerror("multiline comment cannot be nested") ; }
<ML_COMMENT><<EOF>>     	{ BEGIN(INITIAL) ; yyerror("multiline comment was not closed") ; }
<ML_COMMENT>[^*/\n]*    
<ML_COMMENT>"/"[^*/\n]* 
<ML_COMMENT>"*"[^*/\n]* 
<ML_COMMENT>\n     		
<ML_COMMENT>"*/"      		{ BEGIN(INITIAL) ; }


<INITIAL>"//"           	{ BEGIN(SL_COMMENT) ; }
<SL_COMMENT>[^\n]*      
<SL_COMMENT>\n          	{ BEGIN(INITIAL) ; }
<SL_COMMENT><<EOF>>     	{ BEGIN(INITIAL) ; }

"["                         { return OPENING_SQUARE_BRACKET ; }
"]"                         { return CLOSING_SQUARE_BRACKET ; }
"("                         { return OPENING_ROUND_BRACKET ; }
")"                         { return CLOSING_ROUND_BRACKET ; }
"{"                         { return OPENING_CURLY_BRACKET ; }
"}"                         { return CLOSING_CURLY_BRACKET ; }


"."                         { return DOT ; }
"->"                        { return ARROW_OP ; } 


"++"                        { return UNARY_INCREMENT_OP ; }
"--"                        { return UNARY_DECREMENT_OP ; }

"+"                         { return ADDITION_OP ; }
"-"                         { return SUBTRACTION_OP ; }
"*"                         { return MULTIPLICATION_OP ; }
"/"                         { return DIVISION_OP ; }
"%"                         { return MODULUS_OP ; }

">>"                        { return RIGHT_SHIFT_OP ; }
"<<"                        { return LEFT_SHIFT_OP ; }

"<"                         { return LESS_THAN_OP ; }
">"                         { return GREATER_THAN_OP ; }
"<="                        { return LESS_THAN_EQUAL_OP ; }
">="                        { return GREATER_THAN_EQUAL_OP ; }
"=="                        { return EQUALITY_OP ; }
"!="                        { return INEQUALITY_OP ; } 

"~"                         { return BITWISE_NOT_OP ; }
"&"                         { return BITWISE_AND_OP ; }
"^"                         { return BITWISE_XOR_OP ; } 
"|"                         { return BITWISE_OR_OP ; }

"!"                         { return LOGICAL_NOT_OP ; }
"||"                        { return LOGICAL_OR_OP ; }
"&&"                        { return LOGICAL_AND_OP ; }

"?"                         { return QUESTION_MARK ; }
":"                         { return COLON ; }


";"                         { return SEMICOLON ; }

"..."                       { return ELLIPSIS ; }

"="                         { return ASSIGNMENT_OP ; }
"*="                        { return MULT_ASSIGN_OP ; }
"/="                        { return DIV_ASSIGN_OP ; }
"%="                        { return MOD_ASSIGN_OP ; }
"+="                        { return ADD_ASSIGN_OP ; }
"-="                        { return SUB_ASSIGN_OP ; }
"<<="                       { return LSHIFT_ASSIGN_OP ; }
">>="                       { return RSHIFT_ASSIGN_OP ; }

"&="                        { return BITWISE_AND_ASSIGN_OP ; }
"^="                        { return BITWISE_XOR_ASSIGN_OP ; }
"|="                        { return BITWISE_OR_ASSIGN_OP ; }


","                         { return COMMA ; }


"#"                         { return HASH ; }


{ID}            			{ 
								yylval.pointer_to_symbol = __current_ST__->lookup(yytext);
								return IDENTIFIER; /* Identifier Rule */ 
							}
							
							
{STRING_LIT}    			{ 
								// Get the base address to the string
								yylval.pointer_to_char = yytext;
								return STRING_LITERAL; /* String-literal */  
							}
							
{INT_CONST}     			{ 
								// Convert the string to an integer constant
								yylval.integer_value = atoi(yytext);
								return INTEGER_CONST ; /* Integer-Constant Rule */
							}
							
{FLT_CONST}     			{
								// Get the base address to the string 
								yylval.pointer_to_char = yytext;
								return FLOAT_CONST ; /* Float-Constant Rule*/
							}
							
{CHAR_CONST}    			{
								// Get the base address to the string 
								yylval.pointer_to_char = yytext;
								return CHAR_CONST ; /* Character-Constant Rule*/
							}
%%
