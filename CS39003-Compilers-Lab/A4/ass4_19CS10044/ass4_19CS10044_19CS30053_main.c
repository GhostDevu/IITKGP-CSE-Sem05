
//    COMPILERS LABORATORY CS39003
//    ASSIGNMENT O4 -- Parser for tinyC
//    Semester O5 (Autumn 2021-22)
//    Group Members :	Hritaban Ghosh (19CS30053)
//  					Nakul Aggarwal (19CS10044)

#include "stdio.h"
extern int yyparse ( ) ;
extern FILE * yyin ;

int main ( int argc , char ** argv )
{
	printf("\n\n") ;

	yyin = fopen(argv[1], "r") ;
	if (yyin == NULL) 
	{
		printf("  [ FILE %s cannot be opened. Please check the file path again. ] \n\n", argv[1]);
		return 0 ;
	}

    yyparse() ;

	printf("\n\n") ;
	fclose(yyin) ;
    return 0 ;
}
