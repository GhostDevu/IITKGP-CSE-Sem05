
//    COMPILERS LABORATORY CS39003
//    ASSIGNMENT O5 -- Test File 03
//    Semester O5 (Autumn 2021-22)
//    Group Members :	Hritaban Ghosh (19CS30053)
//  					Nakul Aggarwal (19CS10044)
//  [ DECLARATIONS PHASE -- ARRAY/POINTER/VARIABLE/FUNCTION DECLARATIONS ]

void * func ( int * ptr , float * fptr , char * str , int i , float f , char c ) ;

int main ( ) {
	int a = 4 ;
	int * ptr = &a ;
	int x , A[128] ;
	float y = 4.88e-2 , B[63] ;
	char c = 'A' ;
	char * cptr = &c ;
	char str[] = "compiler" ;
	int b = (*ptr) + c ;
	float * fptr = &y ;
	float * fptr_ = B ;
	char C[12][13] ;
	C[4][6] = 'G' ;
	C[1][0] = (char)19 ;
	C[10][5] = (char)2.33 ;
	C[7][11] = c ;
	C[11][1] = (char)(A[99]) ;
	B[61] = A[90] ;
	b = a * (a + c) ;
	return 0 ;
}
