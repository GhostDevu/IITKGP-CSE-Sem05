
//    COMPILERS LABORATORY CS39003
//    ASSIGNMENT O5 -- Test File 02
//    Semester O5 (Autumn 2021-22)
//    Group Members :	Hritaban Ghosh (19CS30053)
//  					Nakul Aggarwal (19CS10044)
//  [ DECLARATIONS PHASE -- FUNCTION DEFINITIONS & ARRAYS ]

int Tak ( int x , int y , int z ) {
	if ( y >= x )	return z ;
	int t1 = Tak(x-1, y, z) ;
	int t2 = Tak(y-1, z, x) ;
	int t3 = Tak(z-1, x, y) ;
	return Tak(t1, t2, t3) ;
}

int * Do_Tak ( int * A , int * B , int * C , int n , int * res ) {
	for ( int i = 0 ; i < n ; i = i + 1 ) {
		res[i] = Tak(A[i], B[i], C[i]) ;
	}
	return res ;
}

int RecH ( int w , int x , int y , int z ) {
	return (
		Tak(x, y, z) + Tak(y, z, w) + Tak(z, w, x) + Tak(w, x, y)
	) / 4 ;
}

int RecF ( int x , int y , int z ) {
	return Tak(
		RecH(x, y, z, x * y),
		RecH(x, y, z, y * z),
		RecH(x, y, z, z * x)
	) ;
}

int RecG ( int w , int x , int y , int z ) {
	if ( w <= 0 || x <= 0 || y <= 0 || z <= 0 )	return 0 ;
	int t1 = RecF(w-1, x, y) ;
	int t2 = RecF(x-1, y, z) ;
	int t3 = RecF(y-1, z, w) ;
	int t4 = RecF(z-1, w, x) ;
	int a = (t1 + t2 + t3) / 3 ;
	int b = (t2 + t3 + t4) / 3 ;
	int c = (t3 + t4 + t1) / 3 ;
	int p = RecG(t1, t2, t3, t4) ;
	int q = RecF(a, b, c) ;
	if ( p < q )	return p ;
	return q ;
}

int Find ( int key , int * A , int n ) {
	for ( int i = 0 ; i < n ; i = i + 1 ) {
		if ( A[i] == key )	return i ;
		else	continue ;
	}
	return -1 ;
}

char * Greeting ( ) {
	return "Welcome!" ;
}

int F ( int * A , int n , float thresh ) {
	for ( int k = 0 ; k < n ; k = k + 1 )
		if ( A[k] > thresh )	return A[k] ;
	return 0 ;
}

int main ( ) {
	Greeting() ;
    int A[10] , B[10] , C[10] ;
	for ( int k = 0 ; k < 10 ; k = k + 1 ) {
		if ( k == 0 ) {
			A[k] = 1 ; 
			B[k] = A[k] + 1 ; 
			C[k] = B[k] - 2 ;
		}
		else if ( k == 1 ) {
			A[k] = 2 ; 
			B[k] = A[k] - 1 ; 
			C[k] = B[k] - 3 ;
		}
		else if ( k == 2 ) {
			A[k] = 3 ; 
			B[k] = A[k] - 3 ; 
			C[k] = B[k] + 2 ;
		}
		else {
			A[k] = RecF(A[k-1], A[k-2], A[k-3]) ;
			B[k] = RecF(B[k-1], B[k-2], B[k-3]) ;
			C[k] = RecF(C[k-1], C[k-2], C[k-3]) ;
		}
	}

	int res[10] ;
	Do_Tak(A, B, C, 10, res) ;

	return 0 ;
}
