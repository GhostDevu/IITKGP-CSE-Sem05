
/*
  COMPILERS LABORATORY CS39003
  ASSIGNMENT O3 -- Lexer for tinyC
  Semester O5 (Autumn 2021-22)
  Group Members :   Hritaban Ghosh (19CS30053)
                    Nakul Aggarwal (19CS10044)
*/

#include <stdio.h>
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
extern char * yytext ;
extern FILE * yyin ;

int main ( int argc , char ** argv )
{
	printf("\n\n\n");

	yyin = fopen(argv[1], "r");
	if (yyin == NULL) 
	{
		printf("  [ FILE %s cannot be opened. Please check the file path again. ] \n\n\n\n", argv[1]);
		return 1;
	}

    int token;
    while(token = yylex())
    {
        switch(token) 
        {
            case __KEYWORD:
		        printf(" <KEYWORD, %d, %s>\n", token, yytext); 
		        break;
            
			case __IDENTIFIER:
		        printf(" <IDENTIFIER, %d, %s>\n", token, yytext); 
		        break;
            
			case __INTEGER_CONST:
		        printf(" <INTEGER_CONST, %d, %s>\n", token, yytext); 
		        break;
            
			case __FLOAT_CONST:
		        printf(" <FLOAT_CONST, %d, %s>\n", token, yytext); 
		        break;
			
			case __ENUMERATION_CONST:
				printf(" <ENUMERATION_CONST, %d, %s>\n", token, yytext); 
		        break;
            
			case __CHARACTER_CONST:
		        printf(" <CHARACTER_CONST, %d, %s>\n", token, yytext); 
		        break;
		    
			case __STRING_LITERAL:
		        printf(" <STRING_LITERAL, %d, %s>\n", token, yytext); 
		        break;
		    
			case __PUNCTUATOR:
		        printf(" <PUNCTUATOR, %d, %s>\n", token, yytext); 
		        break;
		    
			case __SINGLE_LINE_COMMENT_BEGIN:
		    	printf("\n <SINGLE_LINE_COMMENT_BEGIN, %d>\n %s", token, yytext);
		    	break;
		    
			case __SINGLE_LINE_COMMENT:
		    	printf(" %s", yytext);
		    	break;
		    
			case __SINGLE_LINE_COMMENT_END:
		    	printf(" %s <SINGLE_LINE_COMMENT_END, %d>\n\n", yytext, token);
		    	break;
		    
			case __MULTI_LINE_COMMENT_BEGIN:
		    	printf("\n <MULTI_LINE_COMMENT_BEGIN, %d>\n %s", token, yytext);
		    	break;
		    
			case __MULTI_LINE_COMMENT:
		    	printf(" %s", yytext);
		    	break;
		    
			case __MULTI_LINE_COMMENT_END:
		    	printf(" %s\n <MULTI_LINE_COMMENT_END, %d>\n\n", yytext, token);
		    	break;
			
			case __NESTED_MULTI_LINE_COMMENT:
				printf(" [ ERROR : Multi-line comments cannot be nested ]\n"); 
		        break;
			
			case __MULTILINE_COMMENT_NOT_CLOSED:
				printf(" [ ERROR : File ended before multi-line comment was closed ]\n"); 
				break;
            
			default:	break;
        }
    }
	printf("\n\n\n");
	fclose(yyin);

    return 0;
}
