
//    COMPILERS LABORATORY CS39003
//    ASSIGNMENT O6 -- Test File 01
//    Semester O5 (Autumn 2021-22)
//    Group Members :	Hritaban Ghosh (19CS30053)
//  					Nakul Aggarwal (19CS10044)
//    [ Recursive computation of Fibonnaci & Tribonacci Numbers ]

int readInt ( int * arg ) ;
int printInt ( int arg ) ;
int printStr ( char * arg ) ;

int FiboRec ( int n ) {
    if ( n <= 0 )   return -1 ; // erroneous input
    if ( n == 1 )   return 0 ;
    if ( n == 2 )   return 1 ;
    return FiboRec(n-1) + FiboRec(n-2) ;
}

int TriboRec ( int n ) {
    if ( n <= 0 )   return -1 ; // erroneous input
    if ( n == 1 )   return 0 ;
    if ( n == 2 )   return 1 ;
    if ( n == 3 )   return 2 ;
    return TriboRec(n-1) + TriboRec(n-2) + TriboRec(n-3) ;
}

int main ( ) {
    printStr("\n\n") ;
    int n ;
    printStr(" Enter n (< 20) : ") ;
    readInt(&n) ;
    
    printStr(" nth Fibo no. : ") ; printInt(FiboRec(n)) ;
    printStr("\n nth Tribo no. : ") ; printInt(TriboRec(n)) ;
    printStr("\n\n") ;
}