
//    COMPILERS LABORATORY CS39003
//    ASSIGNMENT O6 -- Test File 02
//    Semester O5 (Autumn 2021-22)
//    Group Members :	Hritaban Ghosh (19CS30053)
//  					Nakul Aggarwal (19CS10044)
//    [ Iterative computation of Fibonnaci & Tribonacci Numbers ]

int readInt ( int * arg ) ;
int printInt ( int arg ) ;
int printStr ( char * arg ) ;

int FiboIter ( int n ) {
    if ( n <= 0 )   return -1 ; // erroneous input
    if ( n == 1 )   return 0 ;
    if ( n == 2 )   return 1 ;
    int last_1 = 0 ;
	int last_2 = 1 ;
	int ans = 1 ;
	for ( int i = 4 ; i <= n ; i ++ ) {
		last_1 = last_2 ;
		last_2 = ans ;
		ans = last_1 + last_2 ;
	}
	return ans ;
}

int TriboIter ( int n ) {
    if ( n <= 0 )   return -1 ; // erroneous input
    if ( n == 1 )   return 0 ;
    if ( n == 2 )   return 1 ;
    if ( n == 3 )   return 2 ;
    int last_1 = 0 ;
	int last_2 = 1 ;
	int last_3 = 2 ;
	int ans = 3 ;
	for ( int i = 5 ; i <= n ; i ++ ) {
		last_1 = last_2 ;
		last_2 = last_3 ;
		last_3 = ans ;
		ans = last_1 + last_2 + last_3 ;
	}
	return ans ;
}

int main ( ) {
    printStr("\n\n") ;
    int n ;
    printStr(" Enter n (< 20) : ") ;
    readInt(&n) ;
    
    printStr(" nth Fibo no. : ") ; printInt(FiboIter(n)) ;
    printStr("\n nth Tribo no. : ") ; printInt(TriboIter(n)) ;
    printStr("\n\n") ;
}