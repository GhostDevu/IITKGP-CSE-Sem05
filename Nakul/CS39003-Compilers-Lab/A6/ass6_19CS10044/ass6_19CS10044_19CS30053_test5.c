
//    COMPILERS LABORATORY CS39003
//    ASSIGNMENT O6 -- Test File 05
//    Semester O5 (Autumn 2021-22)
//    Group Members :	Hritaban Ghosh (19CS30053)
//  					Nakul Aggarwal (19CS10044)
//    [ Write a library in tinyC that supports various operations in Vector Algebra ]

int readInt ( int * arg ) ;
int printInt ( int arg ) ;
int printStr ( char * arg ) ;

int Norm2Sq ( int * vec , int l ) {
    if ( l <= 0 )   return -1 ;
    int norm = 0 ;
    for ( int i = 0 ; i < l ; i ++ )
        norm = norm + (vec[i] * vec[i]) ;
    return norm ;
}

int NormInf ( int * vec , int l ) {
    if ( l <= 0 )   return -1 ;
    int max = vec[0] ;
    for ( int i = 0 ; i < l ; i ++ ) {
        if ( vec[i] > max )
            max = vec[i] ;
    }
    return max ;
}

int Dot ( int * vec1 , int * vec2 , int l1 , int l2 ) {
    if ( l1 <= 0 || l2 <= 0 )   return -1 ;
    if ( l1 != l2 ) return -1 ;
    int dotp = 0 ;
    for ( int i = 0 ; i < l1 ; i ++ )
        dotp = dotp + (vec1[i] * vec2[i]) ;
    return dotp ;
}

int Cross ( int * vec1 , int * vec2 , int l1 , int l2 ) {
    printStr(" ** Function not available currently **") ;
    return -1 ;
}

int Max ( int * vec , int l ) {
    return NormInf(vec, l) ;
}

int Min ( int * vec , int l ) {
    if ( l <= 0 )   return -1 ;
    int min = vec[0] ;
    for ( int i = 0 ; i < l ; i ++ ) {
        if ( vec[i] < min )
            min = vec[i] ;
    }
    return min ;
}

void Reverse ( int * vec , int l ) {
    for ( int i = 0 ; i < l ; i ++ )
        vec[i] = -1 * vec[i] ;
    return ;
}

void ScalarMult ( int * vec , int l , int scal ) {
    for ( int i = 0 ; i < l ; i ++ )
        vec[i] = scal * vec[i] ;
    return ;
}

void Add ( int * vec1 , int * vec2 , int l1 , int l2 , int * res ) {
    if ( l1 <= 0 || l2 <= 0 )   return ;
    if ( l1 != l2 ) return ;
    for ( int i = 0 ; i < l1 ; i ++ )
        res[i] = vec1[i] + vec2[i] ;
    return ;
}

void Copy ( int * vec , int l , int * copy ) {
    for ( int i = 0 ; i < l ; i ++ )
        copy[i] = vec[i] ;
    return ;
}

void Sub ( int * vec1 , int * vec2 , int l1 , int l2 , int * res ) {
    if ( l1 <= 0 || l2 <= 0 )   return ;
    if ( l1 != l2 ) return ;
    Copy(vec2, l2, res) ;
    Reverse(res, l1) ;
    Add(vec1, res, l1, l1, res) ;
    return ;
}

int main ( ) {
    printStr("\n\n") ;
    printStr(" [ +++ LIBRARY || VECTOR ALGEBRA +++ ]\n") ;
    printStr("\n Functions supporting the following operations are defined in the library.") ;
    printStr("\n  >> Square of 2-Norm of a vector") ;
    printStr("\n  >> Infinite-Norm of a vector") ;
    printStr("\n  >> Dot product of two vectors") ;
    printStr("\n  >> Magnitude of cross product of two vectors (under maintainence)") ;
    printStr("\n  >> Maximum element of a vector") ;
    printStr("\n  >> Minimum element of a vector") ;
    printStr("\n  >> Reverse direction of a vector") ;
    printStr("\n  >> Scalar multiplication with a vector") ;
    printStr("\n  >> Vector copy creation") ;
    printStr("\n  >> Vector addition") ;
    printStr("\n  >> Vector subtraction") ;
    printStr("\n\n") ;
    return 0 ;
}
