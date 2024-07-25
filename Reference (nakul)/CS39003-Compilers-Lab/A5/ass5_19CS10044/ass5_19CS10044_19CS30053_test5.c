
//    COMPILERS LABORATORY CS39003
//    ASSIGNMENT O5 -- Test File 05
//    Semester O5 (Autumn 2021-22)
//    Group Members :	Hritaban Ghosh (19CS30053)
//  					Nakul Aggarwal (19CS10044)
//  [ STATEMENTS PHASE -- LOOP CONSTRUCTS, RETURN JUMPS ]

// test for for-loop constructs
int Sum ( int a , int r , int M ) {
    int X[50] ;
    for ( int i = 0 ; i < 50 ; i = i + 1 ) {
        if ( i == 0 )   X[i] = a ;
        else {
            X[i] = (X[i-1] * (r % M)) % M ;
        }
    }

    int sum = 0 ;
    int ctr ;
    for ( ctr = 0 ; ctr < 50 ; ) {
        sum = sum + X[ctr] ;
        ctr = ctr + 1 ;
    }

    return sum ;
}

// test for while-loop constructs
float Sqrt ( int n ) {
    int start = 0 , end = n ;
    int mid ;
    float root ;
 
    while ( start <= end ) {
        mid = (start + end) / 2 ;

        if ( mid * mid == n ) {
            start = end + 1 ;
        }

        else if ( mid * mid < n ) {
            root = start ;
            start = mid + 1 ;
        }
 
        else end = mid - 1 ;
    }

    float inc = 0.1 ;
    int i = 0 ;
    while ( i < 6 ) {
        while (root * root <= n)
            root = root + inc ;
        
        root = root - inc ;
        inc = inc / 10 ;
        i = i + 1 ;
    }
    return root ;
}

// test for nested-for-loop constructs
float FrobNorm ( int A[][10] , int m ) {
    // calculates the frobenius norm of an (mx10) matrix
    int norm = 0 ;
    for ( int i = 0 ; i < m ; i = i + 1 ) {
        for ( int j = 0 ; j < 10 ; j = j + 1 ) {
            int ijth_el = A[i][j] ;
            norm = norm + ijth_el * ijth_el ;
        }
    }
    return Sqrt(norm) ;
}

// test for do-while-loop constructs
int Largest ( int * A , int n ) {
    int lar = A[0] ;
    int larIdx = 0 ;

    int c = 0 ;
    do {
        if ( lar < A[c] ) {
            lar = A[c] ;
            larIdx = c ;
        }
        c = c + 1 ;
    } while ( c < n ) ;

    return lar ;
}

int main ( ) {
    int s = Sum(13, 7, 1001) ;

    int A[8][10] ;
    for ( int i = 0 ; i < 8 ; i = i + 1 )
        for ( int j = 0 ; j < 10 ; j = j + 1 )
            A[i][j] = ((i + 2) * (j + 2)) % 91 ;
    float norm = FrobNorm(A, 8) ;

    int B[10] ;
    for ( int i = 0 ; i < 10 ; i = i + 1 )
        B[i] = (i*i + 4*i + 5) % 19 ;
    int l = Largest(B, 10) ;

    return 0 ;
}
