
//    COMPILERS LABORATORY CS39003
//    ASSIGNMENT O6 -- Test File 03
//    Semester O5 (Autumn 2021-22)
//    Group Members :	Hritaban Ghosh (19CS30053)
//  					Nakul Aggarwal (19CS10044)
//    [ Computing GCD & LCM of 2 natural numbers ]

int readInt ( int * arg ) ;
int printInt ( int arg ) ;
int printStr ( char * arg ) ;

int GCD ( int a , int b ) {
    if ( b == 0 )  return a ;
    return GCD(b, a % b) ;
}

int LCM ( int a , int b ) {
    int gcd = GCD(a, b) ;
    int prod = a * b ;
    return prod / gcd ;
}

int main ( ) {
    printStr("\n\n") ;
    int x, y ;
    printStr(" Enter 1st no. : ") ; readInt(&x) ;
    printStr(" Enter 2nd no. : ") ; readInt(&y) ;

    if ( x <= 0 || y <= 0 ) {
        printStr(" [Numbers must be strictly positive]\n\n") ;
        return 0 ;
    }

    printStr(" GCD : ") ; printInt(GCD(x, y)) ;
    printStr("\n LCM : ") ; printInt(LCM(x, y)) ;
    
    printStr("\n\n") ;
}